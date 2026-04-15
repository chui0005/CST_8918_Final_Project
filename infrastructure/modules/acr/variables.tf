variable "acr_name" {
  description = "Name of the Azure Container Registry (globally unique, alphanumeric only)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the ACR is deployed."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "SKU tier for the ACR. Valid values: Basic, Standard, Premium."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Whether the ACR admin account is enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the ACR."
  type        = map(string)
  default     = {}
}
