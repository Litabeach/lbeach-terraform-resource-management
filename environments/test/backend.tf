terraform {
  backend "azurerm" {
    resource_group_name  = "${local.prefix}-rg-01"
    storage_account_name = "${local.restricted_prefix}-sa-01"
    container_name       = "test-blob-container"
    key                  = "test.tfstate"
  }
}