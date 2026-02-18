module "tiny_workload" {
  source                 = "../../modules/tiny_workload"
  resource_naming_prefix = local.resource_naming_prefix
  restricted_resource_naming_prefix = local.restricted_resource_naming_prefix
  location               = var.location
  tags                   = local.tags
  release = var.release
} 

# Import resource group
import {
  to = module.tiny_workload.azurerm_resource_group.rg
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_naming_prefix}-rg-01"
}

# Import storage acct
import {
  to = module.tiny_workload.azurerm_storage_account.storage
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_naming_prefix}-rg-01/providers/Microsoft.Storage/storageAccounts/${local.restricted_resource_naming_prefix}sa01"
}

#Import storage container
import {
  to = module.tiny_workload.azurerm_storage_container.tfstate
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_naming_prefix}-rg-01/providers/Microsoft.Storage/storageAccounts/${local.restricted_resource_naming_prefix}sa01/blobServices/default/containers/tfstate"
}