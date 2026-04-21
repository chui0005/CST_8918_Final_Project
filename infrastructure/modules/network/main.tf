resource "azurerm_resource_group" "network" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_resource_group" "network" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_name     = var.create_resource_group ? azurerm_resource_group.network[0].name : data.azurerm_resource_group.network[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.network[0].location : data.azurerm_resource_group.network[0].location
  resource_group_id       = var.create_resource_group ? azurerm_resource_group.network[0].id : data.azurerm_resource_group.network[0].id
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-cst8918-group-${var.group_number}-${var.environment}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_config

  name                 = "subnet-${each.key}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}
