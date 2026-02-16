terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-assignment1-temp-rg-01"
    storage_account_name = "lbeacha1tempsa01sa01"
    container_name       = "tfstate-container"
    key                  = "test.tfstate"
  }
}