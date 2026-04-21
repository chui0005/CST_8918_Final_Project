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

variable "github_actions_oidc_extra_branch_refs" {
  description = "Branch names (no refs/heads/ prefix) that may run GitHub Actions with OIDC on push or workflow_dispatch, e.g. feat/github-actions-ci so terraform plan runs before a PR exists."
  type        = list(string)
  default     = ["feat/github-actions-ci"]
}

variable "tfstate_resource_group_name" {
  description = "Resource group that contains the Terraform remote state storage account."
  type        = string
  default     = "kutt0011-cst8918-tf-backend"
}

variable "tfstate_storage_account_name" {
  description = "Storage account used by the Terraform remote backend."
  type        = string
  default     = "041164341tfstorage"
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
