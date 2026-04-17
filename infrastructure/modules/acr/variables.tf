variable "registry_name" {
  description = "Globally unique ACR name (alphanumeric only, 5-50 characters)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that hosts the registry."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "ACR SKU (Basic, Standard, Premium)."
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Tags applied to the registry."
  type        = map(string)
  default     = {}
}
