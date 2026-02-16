resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_naming_prefix}-rg-01"
  location = var.location
  tags = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.restricted_resource_naming_prefix}sa01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstatestoragecontainer"
  storage_account_id = azurerm_storage_account.sa.id
  container_access_type = "private"
}