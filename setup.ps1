param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "test")]
    [string]$EnvName
)

# --- Function to parse .tfvars ---
function Get-TfVars {
    param([string]$FilePath)
    $Vars = @{}
    if (Test-Path $FilePath) {
        $Content = Get-Content $FilePath
        foreach ($line in $Content) {
            if ($line -match '^\s*(?<key>\w+)\s*=\s*"(?<value>.+)"') {
                $Vars[$Matches.key] = $Matches.value
            }
        }
    }
    return $Vars
}

# --- 1. Path Logic ---
# Points to environments/dev/dev.auto.tfvars or environments/test/test.auto.tfvars
$EnvPath = "./environments/$EnvName"
$VarFile = "$EnvPath/$EnvName.auto.tfvars"

if (-not (Test-Path $VarFile)) {
    Write-Error "Could not find var file at $VarFile"
    exit
}

# --- 2. Load Variables ---
$Vars = Get-TfVars -FilePath $VarFile

# --- 3. Construct Names ---
$Prefix = "$($Vars.owner)-$($Vars.assignment)-$($Vars.lifespan)-$($Vars.environment)"
$Restricted_Prefix = "$($Vars.owner)$($Vars.assignment)$($Vars.lifespan)$($Vars.environment)"

$RESOURCE_GROUP  = "$($Prefix)-rg-01"
$STORAGE_ACCOUNT = "$($Restricted_Prefix)sa01"
$CONTAINER_NAME  = "tfstate"
$LOCATION        = "$($Vars.location)"
$SUBSCRIPTION_ID = "$($Vars.subscription_id)"

# --- 4. Azure Operations ---
az account set --subscription $SUBSCRIPTION_ID

Write-Host "--- Bootstrapping $EnvName Backend ---" -ForegroundColor Cyan
az group create --name $RESOURCE_GROUP --location $LOCATION
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --sku Standard_LRS
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT --auth-mode login

# --- 5. Terraform Operations ---
Write-Host "--- Switching to $EnvPath ---" -ForegroundColor Yellow
Push-Location $EnvPath

Write-Host "--- Initializing Terraform ---" -ForegroundColor Cyan
terraform init -reconfigure `
    -backend-config="resource_group_name=$RESOURCE_GROUP" `
    -backend-config="storage_account_name=$STORAGE_ACCOUNT" `
    -backend-config="container_name=$CONTAINER_NAME" `
    -backend-config="key=$EnvName.tfstate"

Pop-Location
Write-Host "--- $EnvName Environment Ready ---" -ForegroundColor Green

$Response = Read-Host "Would you like to run 'terraform apply' for $EnvName now? (y/n)"
if ($Response -eq 'y') {
    Push-Location "./environments/$EnvName"
    terraform apply -auto-approve 
    Pop-Location
}