terraform {
  backend "azurerm" {
    resource_group_name  = "kutt0011-cst8918-tf-backend"
    storage_account_name = "041164341tfstorage"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
    use_azuread_auth     = true
  }
}
