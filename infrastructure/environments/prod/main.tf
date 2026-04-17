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
  environment         = "prod"

  vnet_address_space = ["10.0.0.0/14"]
  subnet_config = {
    prod  = "10.0.0.0/16"
    test  = "10.1.0.0/16"
    dev   = "10.2.0.0/16"
    admin = "10.3.0.0/16"
  }

  tags = var.tags
}

module "aks_prod" {
  source = "../../modules/aks"

  cluster_name        = "aks-cst8918-prod-group-${var.group_number}"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  dns_prefix          = "cst8918-prod-${var.group_number}"
  kubernetes_version  = "1.32"
  vnet_subnet_id      = module.network.subnet_ids["prod"]

  node_vm_size       = "Standard_B2s"
  enable_autoscaling = true
  min_node_count     = 1
  max_node_count     = 3

  tags = var.tags
}

# ACR is created by the test environment stack; prod cluster needs pull access for CI/CD images.
data "azurerm_container_registry" "weather" {
  name                = "cst8918acr${var.group_number}"
  resource_group_name = "cst8918-final-project-group-${var.group_number}"
}

resource "azurerm_role_assignment" "aks_prod_kubelet_acr_pull" {
  scope                = data.azurerm_container_registry.weather.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_prod.kubelet_identity_object_id
}
