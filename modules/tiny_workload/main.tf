resource "azurerm_resource_group" "workload" {
  name     = "${local.prefix}-rg-01"
  location = var.location
  tags = local.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "${local.restricted_prefix}sa01"
  resource_group_name      = azurerm_resource_group.workload.name
  location                 = azurerm_resource_group.workload.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "${var.environment}storagecontainer"
  storage_account_id = azurerm_storage_account.sa.id
  container_access_type = "private"
}