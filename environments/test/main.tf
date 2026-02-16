# Configure backend
terraform {
  backend "azurerm" {
    resource_group_name  = "var.rg"
    storage_account_name = "var.sa"
    container_name       = "var.sa"
    key                  = "test.tfstate"
  }
}