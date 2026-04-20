terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kubeconfig_context
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

module "acr" {
  source              = "../../modules/acr"
  acr_name            = "cst8918acr${var.group_number}"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

module "aks_test" {
  source = "../../modules/aks"

  cluster_name        = "aks-cst8918-test-group-${var.group_number}"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  dns_prefix          = "cst8918-test-${var.group_number}"
  kubernetes_version  = "1.34"
  vnet_subnet_id      = module.network.subnet_ids["test"]
  acr_id              = module.acr.acr_id
  attach_acr          = true

  node_vm_size       = "Standard_B2s"
  node_count         = 1
  enable_autoscaling = false

  tags = var.tags
}

module "redis" {
  source              = "../../modules/redis"
  name                = "test-redis-${var.group_number}st"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  sku_name            = var.redis_sku_name
  family              = var.redis_family
  capacity            = var.redis_capacity
  tags                = var.tags
}

module "app" {
  source = "../../modules/app"

  providers = {
    kubernetes = kubernetes
  }

  app_name        = var.app_name
  namespace       = var.app_namespace
  image           = "${module.acr.acr_login_server}/${var.image_repository}:${var.image_tag}"
  redis_host      = module.redis.redis_hostname
  redis_port      = module.redis.redis_ssl_port
  weather_api_key = var.weather_api_key
  redis_password  = module.redis.primary_access_key
  replicas        = var.app_replicas

  depends_on = [module.aks_test]
}
