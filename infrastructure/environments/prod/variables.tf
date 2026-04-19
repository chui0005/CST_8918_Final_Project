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

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file used by the Kubernetes provider."
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Optional kubeconfig context for the prod AKS cluster."
  type        = string
  default     = null
}

variable "acr_sku" {
  description = "SKU tier for the prod ACR instance."
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Whether the prod ACR admin account is enabled."
  type        = bool
  default     = false
}

variable "redis_sku_name" {
  description = "Redis SKU name for the prod environment."
  type        = string
  default     = "Standard"
}

variable "redis_family" {
  description = "Redis family for the prod environment."
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Redis capacity for the prod environment."
  type        = number
  default     = 1
}

variable "app_name" {
  description = "Kubernetes deployment name for the weather app."
  type        = string
  default     = "weather-app"
}

variable "app_namespace" {
  description = "Kubernetes namespace for the weather app."
  type        = string
  default     = "weather-prod"
}

variable "image_repository" {
  description = "Repository name used for the weather app image."
  type        = string
  default     = "weather"
}

variable "image_tag" {
  description = "Container image tag used for the weather app."
  type        = string
  default     = "latest"
}

variable "app_replicas" {
  description = "Replica count for the prod weather app deployment."
  type        = number
  default     = 2
}

variable "weather_api_key" {
  description = "OpenWeather API key used by the Remix Weather app."
  type        = string
  sensitive   = true
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
