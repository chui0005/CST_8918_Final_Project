variable "group_number" {
  description = "Group number used in Azure resource naming (must match environments)."
  type        = string
  default     = "9"
}

variable "location" {
  description = "Azure region for the user-assigned identity."
  type        = string
  default     = "canadacentral"
}

variable "github_repository" {
  description = "GitHub repository in org/repo form for OIDC subject matching."
  type        = string
  default     = "chui0005/CST_8918_Final_Project"
}

variable "tfstate_resource_group_name" {
  description = "Resource group that contains the Terraform remote state storage account."
  type        = string
  default     = "rg-cst8918-tfstate"
}

variable "tfstate_storage_account_name" {
  description = "Storage account used by the Terraform remote backend."
  type        = string
  default     = "cst8918tfstate9"
}

variable "tags" {
  description = "Tags applied to the user-assigned identity."
  type        = map(string)
  default = {
    project    = "cst8918-final"
    managed_by = "terraform"
    component  = "github-actions-oidc"
  }
}
