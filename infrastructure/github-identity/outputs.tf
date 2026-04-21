output "github_actions_identity_client_id" {
  description = "Set as GitHub repository variable AZURE_CLIENT_ID for OIDC login in workflows."
  value       = azurerm_user_assigned_identity.github_actions.client_id
}

output "github_actions_identity_principal_id" {
  description = "Object ID of the GitHub Actions user-assigned identity."
  value       = azurerm_user_assigned_identity.github_actions.principal_id
}

output "github_actions_identity_id" {
  description = "Resource ID of the user-assigned identity."
  value       = azurerm_user_assigned_identity.github_actions.id
}

output "github_actions_identity_name" {
  description = "Name of the user-assigned identity."
  value       = azurerm_user_assigned_identity.github_actions.name
}
