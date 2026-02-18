# 1. Variables - Update these to match your Assignment requirements
$RESOURCE_GROUP = "rg-terraform-mgmt"
$STORAGE_ACCOUNT = "" # Storage names must be unique
$CONTAINER_NAME = "tfstate"
$LOCATION = "eastus"

# 2. Authenticate (Optional - uncomment if not logged in)
# az login

Write-Host "--- Starting Backend Bootstrap ---" -ForegroundColor Cyan

# Create Resource Group
Write-Host "Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Storage Account
Write-Host "Creating Storage Account: $STORAGE_ACCOUNT..."
az storage account create `
    --resource-group $RESOURCE_GROUP `
    --name $STORAGE_ACCOUNT `
    --sku Standard_LRS `
    --encryption-services blob

# Create Storage Container
Write-Host "Creating Blob Container..."
az storage container create `
    --name $CONTAINER_NAME `
    --account-name $STORAGE_ACCOUNT

Write-Host "--- Initializing Terraform ---" -ForegroundColor Cyan

# Change directory to your environment (e.g., dev or prod)
# cd environments/dev 

terraform init `
    -backend-config="resource_group_name=$RESOURCE_GROUP" `
    -backend-config="storage_account_name=$STORAGE_ACCOUNT" `
    -backend-config="container_name=$CONTAINER_NAME" `
    -backend-config="key=terraform.tfstate"

Write-Host "--- Environment Ready ---" -ForegroundColor Green