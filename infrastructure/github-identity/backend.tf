terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cst8918-tfstate"
    storage_account_name = "cst8918tfstate9"
    container_name       = "tfstate"
    key                  = "github-identity/terraform.tfstate"
    # Bootstrap this stack once locally with `az login` before OIDC exists.
    use_oidc = false
  }
}
