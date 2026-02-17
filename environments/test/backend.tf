terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg5-temp-test-rg-01"
    storage_account_name = "lbeachasg5temptestsa01"
    container_name       = "tfstatestoragecontainer"
    key = "test.tfstate"
  }
}