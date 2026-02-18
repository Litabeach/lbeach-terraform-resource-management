locals {
  resource_naming_prefix            = "${var.owner}-${var.assignment}-${var.lifespan}-${var.environment}"
  restricted_resource_naming_prefix = replace(local.resource_naming_prefix, "/-/", "")
  container_name = "tfstate"


  tags = {
    owner       = var.owner
    environment = var.environment
    lifespan    = var.lifespan
    assignment  = var.assignment
    release     = var.release
  }
}