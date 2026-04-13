terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cst8918-tfstate"
    storage_account_name = "cst8918tfstate9" # update after bootstrap
    container_name       = "tfstate"
    key                  = "test/terraform.tfstate"
    use_oidc             = true
  }
}
