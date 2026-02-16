locals {
  location          = "centralus"
  prefix            = "${var.owner}-${var.assignment}-${var.lifespan}-${var.environment}"
  restricted_prefix = replace(local.prefix, "/-/", "")

  common_tags = {
    owner       = var.owner
    environment = var.environment
    lifespan    = var.lifespan
    assignment = var.assignment
  }
}