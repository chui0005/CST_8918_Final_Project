terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

module "network" {
  source = "../../modules/network"

  resource_group_name = "cst8918-final-project-group-${var.group_number}"
  location            = var.location
  group_number        = var.group_number
  environment         = "test"

  vnet_address_space = ["10.0.0.0/14"]
  subnet_config = {
    prod  = "10.0.0.0/16"
    test  = "10.1.0.0/16"
    dev   = "10.2.0.0/16"
    admin = "10.3.0.0/16"
  }

  tags = var.tags
}

module "aks_test" {
  source = "../../modules/aks"

  cluster_name        = "aks-cst8918-test-group-${var.group_number}"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  dns_prefix          = "cst8918-test-${var.group_number}"
  kubernetes_version  = "1.34"
  vnet_subnet_id      = module.network.subnet_ids["test"]

  node_vm_size       = "Standard_B2s"
  node_count         = 1
  enable_autoscaling = false

  tags = var.tags
}

module "acr" {
  source = "../../modules/acr"

  registry_name       = "cst8918acr${var.group_number}"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  sku                 = "Basic"
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_test_kubelet_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_test.kubelet_identity_object_id
}
