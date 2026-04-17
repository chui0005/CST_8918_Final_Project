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

data "azurerm_resource_group" "project" {
  name = "cst8918-final-project-group-${var.group_number}"
}

data "azurerm_storage_account" "tfstate" {
  name                = var.tfstate_storage_account_name
  resource_group_name = var.tfstate_resource_group_name
}

data "azurerm_container_registry" "shared" {
  name                = "cst8918acr${var.group_number}"
  resource_group_name = data.azurerm_resource_group.project.name
}

data "azurerm_kubernetes_cluster" "test" {
  name                = "aks-cst8918-test-group-${var.group_number}"
  resource_group_name = data.azurerm_resource_group.project.name
}

data "azurerm_kubernetes_cluster" "prod" {
  name                = "aks-cst8918-prod-group-${var.group_number}"
  resource_group_name = data.azurerm_resource_group.project.name
}

resource "azurerm_user_assigned_identity" "github_actions" {
  name                = "id-github-actions-cst8918-${var.group_number}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.project.name

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "github_main" {
  name                = "github-ref-refs-heads-main"
  resource_group_name = data.azurerm_resource_group.project.name
  parent_id           = azurerm_user_assigned_identity.github_actions.id
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_repository}:ref:refs/heads/main"
  audience = ["api://AzureADTokenExchange"]
}

resource "azurerm_federated_identity_credential" "github_pull_request" {
  name                = "github-pull-request"
  resource_group_name = data.azurerm_resource_group.project.name
  parent_id           = azurerm_user_assigned_identity.github_actions.id
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_repository}:pull_request"
  audience = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "project_rg_contributor" {
  scope                = data.azurerm_resource_group.project.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "tfstate_blob_data_contributor" {
  scope                = data.azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = data.azurerm_container_registry.shared.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "aks_test_cluster_admin" {
  scope                = data.azurerm_kubernetes_cluster.test.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "aks_prod_cluster_admin" {
  scope                = data.azurerm_kubernetes_cluster.prod.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}
