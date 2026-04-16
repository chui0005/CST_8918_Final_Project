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
}

module "backend" {
  source = "../modules/backend"

  resource_group_name  = "rg-cst8918-tfstate"
  location             = "canadacentral"
  storage_account_name = "cst8918tfstate9st" # must be globally unique; append random chars if taken
  container_name       = "tfstate"

  tags = {
    project    = "cst8918-final"
    managed_by = "terraform"
  }
}

output "storage_account_name" {
  description = "Copy this value into each environment's backend.tf storage_account_name field."
  value       = module.backend.storage_account_name
}

output "container_name" {
  description = "Copy this value into each environment's backend.tf container_name field."
  value       = module.backend.container_name
}

output "resource_group_name" {
  description = "Copy this value into each environment's backend.tf resource_group_name field."
  value       = module.backend.resource_group_name
}
