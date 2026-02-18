# Create Resource Group
az group create --name lbeach-asg5-temp-dev-rg-01 --location centralus
az group create --name lbeach-asg5-temp-test-rg-01 --location centralus

# Create Storage Account (Must be globally unique)
az storage account create --name lbeachasg5tempdevsa01 --resource-group lbeach-asg5-temp-dev-rg-01 --sku Standard_LRS --encryption-services blob

az storage account create --name lbeachasg5temptestsa01 --resource-group lbeach-asg5-temp-test-rg-01 --sku Standard_LRS --encryption-services blob

# Create Container
az storage container create --name tfstate --account-name lbeachasg5tempdevsa01 --auth-mode login
az storage container create --name tfstate --account-name lbeachasg5temptestsa01 --auth-mode login


# create key vault
az keyvault create --name "lbeachasg5tempdevkv01" --resource-group "lbeach-asg5-temp-dev-rg-01" --location "CentralUS" --default-action Allow --enable-rbac-authorization false
az keyvault create --name "lbeachasg5temptestkv01" --resource-group "lbeach-asg5-temp-test-rg-01" --location "CentralUS" --default-action Allow --enable-rbac-authorization false


# create secret 
az keyvault secret set --vault-name lbeachasg5tempdevkv01 --name "devpw" --value "potato"
az keyvault secret set --vault-name lbeachasg5temptestkv01 --name "testpw" --value "tomato" 



terraform import module.tiny_workload.azurerm_key_vault_secret.imported_secret https://lbeachasg5tempdevkv01.vault.azure.net/secrets/devpw

erraform import module.tiny_workload.azurerm_storage_account.storage 


asg 5 import
ID = az group show --name lbeach-asg5-temp-dev-rg-01 --query id -o tsv
az storage account show --name lbeachasg5tempdevsa01 --resource-group lbeach-asg5-temp-dev-rg-01 --query id -o ts
az keyvault secret show --name "db-password" --vault-name "kv-assessment-lbeach" --query id -o tsv 

terraform init
terraform import module.tiny_workload.azurerm_resource_group.rg /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01


<!-- import rg -->

terraform import module.tiny_workload.azurerm_resource_group.rg /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01

<!-- import sa -->
terraform import module.tiny_workload.azurerm_storage_account.storage /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01/providers/Microsoft.Storage/storageAccounts/lbeachasg5tempdevsa01

<!-- import s container -->
terraform import module.tiny_workload.azurerm_storage_container.tfstate /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01/providers/Microsoft.Storage/storageAccounts/lbeachasg5tempdevsa01/blobServices/default/containers/tfstate

<!-- import kv -->
terraform import module.tiny_workload.azurerm_key_vault.kv /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01/providers/Microsoft.KeyVault/vaults/lbeachasg5tempdevkv01 

<!-- import kv secret -->
SECRET_ID=$(az keyvault secret show --name "devpw" --vault-name "lbeachasg5tempdevkv01" --query id -o tsv )

terraform import module.tiny_workload.azurerm_key_vault_secret.devpw https://lbeachasg5tempdevkv01.vault.azure.net/secrets/devpw/90e0d07cc09d4aaab0998ed0abd5da18

<!-- 

can alternatley use an import block in your code 

import {
  # The ID of the existing resource in Azure
  id = "/subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg5-temp-dev-rg-01/providers/Microsoft.Storage/storageAccounts/lbeachasg5tempdevsa01"

  # The address you want it to have in your Terraform code
  to = azurerm_storage_account.imported_sa
} -->

az storage account keys list --account-name lbeachasg5tempdevsa01 --resource-group lbeach-asg5-temp-dev-rg-01



Assignment 6 - drift
scenario 1:
change - storage acount drift - network access 
disable public access, change min tls version
az storage account update --name lbeachasg5tempdevsa01 --resource-group lbeach-asg5-temp-dev-rg-01 --min-tls-version TLS1_1 --public-network-access Disabled  

add ip 
az storage account network-rule add --resource-group lbeach-asg5-temp-dev-rg-01 --account-name lbeachasg5tempdevsa01 --ip-address 97.116.0.12

scenario 2: 
tagging (metadata) change



assg 7 slot swap

az webapp deployment slot swap \
  --resource-group lbeach-asg5-temp-dev-rg-01 \
  --name lbeach-asg7-app \
  --slot staging \
  --target-slot production