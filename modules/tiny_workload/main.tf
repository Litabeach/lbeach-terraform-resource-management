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
 
resource "azurerm_key_vault_secret" "devpw" {
  name         = "devpw"
  value        = "potato" # Terraform will manage this value now
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.resource_naming_prefix}-asp-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "S1"
  tags                = var.tags
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_windows_web_app" "app" {
  name                = "${var.resource_naming_prefix}-asp-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  app_settings = {
    "ENV_NAME" = "Staging-v2"
  }
    site_config {}
}

resource "azurerm_windows_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_windows_web_app.app.id
  app_settings = {
    "ENV_NAME" = "Staging-v3"
  }
  site_config {}
}