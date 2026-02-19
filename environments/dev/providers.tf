terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0" # ~ pins to any 3.x version, but not 4.0
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
