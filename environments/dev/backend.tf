terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg2-temp-dev-rg-01"
    storage_account_name = "lbeachasg2tempdevsa01"
    container_name       = "tfstatestoragecontainer"
    key                  = "dev.tfstate"
  }
}