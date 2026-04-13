variable "group_number" {
  description = "Group number used in resource naming."
  type        = string
  default     = "9"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    environment = "prod"
    project     = "cst8918-final"
    managed_by  = "terraform"
  }
}
