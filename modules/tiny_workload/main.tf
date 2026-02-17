data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_naming_prefix}-rg-01"
  location = var.location
  tags = var.tags
}

resource "azurerm_storage_account" "storage" { #renamed from 'sa'
  name                     = "${var.restricted_resource_naming_prefix}sa01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# added this block to change sa name to storage
moved {
  from = azurerm_storage_account.sa
  to   = azurerm_storage_account.storage
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstatestoragecontainer"
  storage_account_id = azurerm_storage_account.storage.id
  container_access_type = "private"
}

  resource "azurerm_key_vault" "kv" {
  name                       = "${var.restricted_resource_naming_prefix}kv01"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
}
 
# imported secret
resource "azurerm_key_vault_secret" "devpw" {
  name         = "devpw"
  value        = "potato" # Terraform will manage this value now
  key_vault_id = azurerm_key_vault.kv.id
}