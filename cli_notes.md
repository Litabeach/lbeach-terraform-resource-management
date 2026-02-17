# Create Resource Group
az group create --name lbeach-asg5-temp-dev-rg-01 --location centralus
az group create --name lbeach-asg5-temp-test-rg-01 --location centralus

# Create Storage Account (Must be globally unique)
az storage account create --name lbeachasg5tempdevsa01 --resource-group lbeach-asg5-temp-dev-rg-01 --sku Standard_LRS --encryption-services blob

az storage account create --name lbeachasg5temptestsa01 --resource-group lbeach-asg5-temp-test-rg-01 --sku Standard_LRS --encryption-services blob

# Create Container
az storage container create --name tfstatestoragecontainer --account-name lbeachasg5tempdevsa01 --auth-mode login
az storage container create --name tfstatestoragecontainer --account-name lbeachasg5temptestsa01 --auth-mode login


# create key vault
az keyvault create --name "lbeachasg5tempdevkv01" --resource-group "lbeach-asg5-temp-dev-rg-01" --location "CentralUS" --default-action Allow --enable-rbac-authorization false
az keyvault create --name "lbeachasg5temptestkv01" --resource-group "lbeach-asg5-temp-test-rg-01" --location "CentralUS" --default-action Allow --enable-rbac-authorization false


# create secret 
az keyvault secret set --vault-name lbeachasg5tempdevkv01 --name "devpw" --value "potato"
az keyvault secret set --vault-name lbeachasg5temptestkv01 --name "testpw" --value "tomato" 



terraform import module.tiny_workload.azurerm_key_vault_secret.imported_secret https://lbeachasg5tempdevkv01.vault.azure.net/secrets/devpw




<!-- after creation, must import state for rg, sa and container
ex :

terraform import module.tiny_workload.azurerm_resource_group.rg /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg2-temp-test-rg-01

terraform import module.tiny_workload.azurerm_storage_account.sa /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg2-temp-test-rg-01/providers/Microsoft.Storage/storageAccounts/lbeachasg2temptestsa01

terraform import module.tiny_workload.azurerm_storage_container.tfstate /subscriptions/f4032010-05af-4abd-8c46-1f5b91077fbe/resourceGroups/lbeach-asg2-temp-test-rg-01/providers/Microsoft.Storage/storageAccounts/lbeachasg2temptestsa01/blobServices/default/containers/tfstatestoragecontainer

-->