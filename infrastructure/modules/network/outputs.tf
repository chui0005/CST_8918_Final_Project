output "resource_group_name" {
  description = "Name of the resource group containing all network resources."
  value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
  description = "Resource ID of the network resource group."
  value       = azurerm_resource_group.network.id
}

output "vnet_id" {
  description = "Resource ID of the virtual network."
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "Map of subnet name to subnet resource ID."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "Map of subnet name to subnet resource name."
  value       = { for k, v in azurerm_subnet.subnets : k => v.name }
}
