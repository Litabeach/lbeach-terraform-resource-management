terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg2-temp-rg-01"
    storage_account_name = "lbeachasg2tempsa01"
    container_name       = "storagecontainer"
    key                  = "dev.tfstate"
  }
}