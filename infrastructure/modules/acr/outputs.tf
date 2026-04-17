output "id" {
  description = "ACR resource ID."
  value       = azurerm_container_registry.main.id
}

output "name" {
  description = "ACR name (short form for az acr login)."
  value       = azurerm_container_registry.main.name
}

output "login_server" {
  description = "Login server hostname (e.g. myregistry.azurecr.io)."
  value       = azurerm_container_registry.main.login_server
}
