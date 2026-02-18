terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg5-temp-dev-rg-01"
    storage_account_name = "lbeachasg5tempdevsa01"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}