variable "resource_group_name" {
  description = "Name of the resource group for the backend storage."
  type        = string
}

variable "location" {
  description = "Azure region for all backend resources."
  type        = string
  default     = "canadacentral"
}

variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase alphanumeric)."
  type        = string
}

variable "container_name" {
  description = "Name of the blob container that holds Terraform state files."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags applied to all backend resources."
  type        = map(string)
  default     = {}
}
