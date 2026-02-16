terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg2-temp-test-rg-01"
    storage_account_name = "lbeachasg2temptestsa01"
    container_name       = "devstoragecontainer"
    key = "test.tfstate"
  }
}