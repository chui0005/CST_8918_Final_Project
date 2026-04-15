resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    node_count           = var.enable_autoscaling ? null : var.node_count
    auto_scaling_enabled = var.enable_autoscaling
    min_count            = var.enable_autoscaling ? var.min_node_count : null
    max_count            = var.enable_autoscaling ? var.max_node_count : null
    vnet_subnet_id       = var.vnet_subnet_id
    os_disk_size_gb      = 30
    os_disk_type         = "Managed"
    type                 = "VirtualMachineScaleSets"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
  }

  local_account_disabled    = true
  automatic_upgrade_channel = "patch"

  tags = var.tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# Grant the node pool (kubelet) identity pull access to ACR.
# Uses kubelet_identity — the identity that runs on nodes and pulls images —
# not identity[0] which is the control-plane identity.
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
