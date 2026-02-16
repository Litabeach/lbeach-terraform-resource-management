# Configure backend
terraform {
  backend "azurerm" {
    resource_group_name  = "${localsprefix}-dev"
    storage_account_name = "${local.restricted_prefix}dev"
    container_name       = "${local.restricted_prefix}dev"
    key                  = "dev.tfstate"
  }
}