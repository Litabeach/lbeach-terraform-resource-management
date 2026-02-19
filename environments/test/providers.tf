terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0" # pinning to 3.x version
    }
  }
}

provider "azurerm" {
  features {
        key_vault {
      purge_soft_delete_on_destroy    = true
    }
  }
  subscription_id = var.subscription_id
}
