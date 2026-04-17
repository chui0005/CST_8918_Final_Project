output "resource_group_name" {
  description = "Name of the primary resource group."
  value       = module.network.resource_group_name
}

output "vnet_id" {
  description = "Resource ID of the virtual network."
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet name to subnet resource ID."
  value       = module.network.subnet_ids
}

output "aks_cluster_name" {
  description = "Name of the test AKS cluster."
  value       = module.aks_test.cluster_name
}

output "aks_cluster_id" {
  description = "Resource ID of the test AKS cluster."
  value       = module.aks_test.cluster_id
}

output "acr_name" {
  description = "ACR short name."
  value       = module.acr.name
}

output "acr_login_server" {
  description = "ACR login server for container image references."
  value       = module.acr.login_server
}
