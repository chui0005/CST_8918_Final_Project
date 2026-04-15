variable "name" {
  description = "Name of the Azure Cache for Redis instance."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the Redis Cache is deployed."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Redis Cache. Valid values: Basic, Standard, Premium."
  type        = string
  default     = "Basic"
}

variable "family" {
  description = "SKU family. Use C for Basic/Standard, P for Premium."
  type        = string
  default     = "C"
}

variable "capacity" {
  description = "Size of the Redis cache (0–6 depending on SKU)."
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags applied to the Redis Cache."
  type        = map(string)
  default     = {}
}
