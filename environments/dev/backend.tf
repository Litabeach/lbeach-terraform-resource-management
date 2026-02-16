terraform {
  backend "azurerm" {
    resource_group_name  = "lbeach-asg2-temp-rg-01"
    storage_account_name = "lbeachasg2tempsa01"
    container_name       = "tfstate-container"
    key                  = "dev.tfstate"
  }
}



# terraform init \
#   -backend-config="resource_group_name=lbeach-assignment1-temp-rg-01" \
#   -backend-config="storage_account_name=lbeacha1tempsa01" \
#   -backend-config="container_name=tfstate-container" \
#   -backend-config="key=dev.tfstate"