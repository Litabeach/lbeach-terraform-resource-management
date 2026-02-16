module "tiny_workload" {
  source                 = "../../modules/tiny_workload"
  resource_naming_prefix = local.resource_naming_prefix
  restricted_resource_naming_prefix = local.restricted_resource_naming_prefix
  location               = var.location
  tags                   = local.tags
  release = var.release
} 