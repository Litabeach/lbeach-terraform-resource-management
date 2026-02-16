locals {
  location          = "centralus"
  prefix            = "${var.owner}-${var.assessment}-${var.environment}"
  restricted_prefix = replace(local.prefix, "/-/", "")

  common_tags = {
    owner       = var.owner
    environment = var.environment
    lifespan    = var.assessment
  }
}