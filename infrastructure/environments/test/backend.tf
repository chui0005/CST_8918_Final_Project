terraform {
  backend "azurerm" {
    resource_group_name  = "kutt0011-cst8918-tf-backend"
    storage_account_name = "041164341tfstorage"
    container_name       = "tfstate"
    key                  = "test/terraform.tfstate"
    # use_oidc: omit so CI picks up ARM_USE_OIDC=true (GitHub OIDC). Locally omit ARM_USE_OIDC and use `az login` (user).
  }
}
