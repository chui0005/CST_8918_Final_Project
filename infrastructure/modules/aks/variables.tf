variable "cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the AKS cluster is deployed."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "canadacentral"
}

variable "kubernetes_version" {
  description = "Kubernetes version for control plane and node pools."
  type        = string
  default     = "1.32"
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster FQDN."
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet ID where node pool VMs are placed."
  type        = string
}

variable "node_vm_size" {
  description = "Azure VM SKU for node pool nodes."
  type        = string
  default     = "Standard_B2s"
}

variable "node_count" {
  description = "Initial node count (and fixed count when autoscaling is disabled)."
  type        = number
  default     = 1
}

variable "enable_autoscaling" {
  description = "Whether to enable cluster autoscaler on the default node pool."
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum node count when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum node count when autoscaling is enabled."
  type        = number
  default     = 3
}

variable "acr_id" {
  description = "Resource ID of ACR to grant AcrPull to the node pool identity. Set to null to skip."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all AKS resources."
  type        = map(string)
  default     = {}
}
