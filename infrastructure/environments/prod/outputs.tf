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
  description = "Name of the prod AKS cluster."
  value       = module.aks_prod.cluster_name
}

output "aks_cluster_id" {
  description = "Resource ID of the prod AKS cluster."
  value       = module.aks_prod.cluster_id
}

output "acr_name" {
  description = "Name of the shared ACR used for images (managed in test stack)."
  value       = data.azurerm_container_registry.weather.name
}

output "acr_id" {
  description = "Resource ID of the shared ACR."
  value       = data.azurerm_container_registry.weather.id
}

output "acr_login_server" {
  description = "Login server for the shared ACR."
  value       = data.azurerm_container_registry.weather.login_server
}

output "redis_name" {
  description = "Name of the prod Redis Cache instance."
  value       = module.redis.redis_name
}

output "redis_hostname" {
  description = "Hostname of the prod Redis Cache instance."
  value       = module.redis.redis_hostname
}

output "app_deployment_name" {
  description = "Kubernetes deployment name for the prod app."
  value       = module.app.deployment_name
}

output "app_service_name" {
  description = "Kubernetes service name for the prod app."
  value       = module.app.service_name
}

output "app_namespace" {
  description = "Kubernetes namespace for the prod app."
  value       = module.app.namespace
}

output "app_image" {
  description = "Fully qualified image name for the prod app."
  value       = "${data.azurerm_container_registry.weather.login_server}/${var.image_repository}:${var.image_tag}"
}
