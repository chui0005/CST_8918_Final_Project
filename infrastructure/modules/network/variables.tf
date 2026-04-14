variable "resource_group_name" {
  description = "Name of the resource group for network resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "canadacentral"
}

variable "group_number" {
  description = "Group number suffix used in naming (e.g., '9')."
  type        = string
  default     = "9"
}

variable "environment" {
  description = "Environment name: test or prod."
  type        = string
  validation {
    condition     = contains(["test", "prod"], var.environment)
    error_message = "environment must be 'test' or 'prod'."
  }
}

variable "vnet_address_space" {
  description = "CIDR block for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/14"]
}

variable "subnet_config" {
  description = "Map of subnet names to their CIDR prefixes."
  type        = map(string)
  default = {
    prod  = "10.0.0.0/16"
    test  = "10.1.0.0/16"
    dev   = "10.2.0.0/16"
    admin = "10.3.0.0/16"
  }
}

variable "tags" {
  description = "Tags applied to all network resources."
  type        = map(string)
  default     = {}
}
