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
  description = "Name of the test ACR instance."
  value       = module.acr.acr_name
}

output "acr_id" {
  description = "Resource ID of the test ACR instance."
  value       = module.acr.acr_id
}

output "acr_login_server" {
  description = "Login server for the test ACR instance."
  value       = module.acr.acr_login_server
}

output "redis_name" {
  description = "Name of the test Redis Cache instance."
  value       = module.redis.redis_name
}

output "redis_hostname" {
  description = "Hostname of the test Redis Cache instance."
  value       = module.redis.redis_hostname
}

output "app_deployment_name" {
  description = "Kubernetes deployment name for the test app."
  value       = module.app.deployment_name
}

output "app_service_name" {
  description = "Kubernetes service name for the test app."
  value       = module.app.service_name
}

output "app_namespace" {
  description = "Kubernetes namespace for the test app."
  value       = module.app.namespace
}

output "app_image" {
  description = "Fully qualified image name for the test app."
  value       = "${module.acr.acr_login_server}/${var.image_repository}:${var.image_tag}"
}
