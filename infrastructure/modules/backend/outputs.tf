output "resource_group_name" {
  description = "Name of the resource group holding the backend."
  value       = azurerm_resource_group.backend.name
}

output "storage_account_name" {
  description = "Name of the storage account (use in backend blocks)."
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "Name of the blob container (use in backend blocks)."
  value       = azurerm_storage_container.tfstate.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = azurerm_storage_account.tfstate.id
}
