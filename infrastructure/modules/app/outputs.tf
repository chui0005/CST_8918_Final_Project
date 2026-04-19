output "namespace" {
  description = "Kubernetes namespace the app is deployed into."
  value       = kubernetes_namespace_v1.app.metadata[0].name
}

output "deployment_name" {
  description = "Name of the Kubernetes deployment."
  value       = kubernetes_deployment_v1.app.metadata[0].name
}

output "service_name" {
  description = "Name of the Kubernetes LoadBalancer service."
  value       = kubernetes_service_v1.app.metadata[0].name
}
