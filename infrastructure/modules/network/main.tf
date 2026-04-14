resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-cst8918-group-${var.group_number}-${var.environment}"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_config

  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}
