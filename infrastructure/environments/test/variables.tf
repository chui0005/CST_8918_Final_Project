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
  description = "Optional kubeconfig context for the test AKS cluster."
  type        = string
  default     = null
}

variable "acr_sku" {
  description = "SKU tier for the test ACR instance."
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Whether the test ACR admin account is enabled."
  type        = bool
  default     = false
}

variable "redis_sku_name" {
  description = "Redis SKU name for the test environment."
  type        = string
  default     = "Basic"
}

variable "redis_family" {
  description = "Redis family for the test environment."
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Redis capacity for the test environment."
  type        = number
  default     = 0
}

variable "app_name" {
  description = "Kubernetes deployment name for the weather app."
  type        = string
  default     = "weather-app"
}

variable "app_namespace" {
  description = "Kubernetes namespace for the weather app."
  type        = string
  default     = "weather-test"
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
  description = "Replica count for the test weather app deployment."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    environment = "test"
    project     = "cst8918-final"
    managed_by  = "terraform"
  }
}

variable "weather_api_key" {
  description = "OpenWeather API key used by the Remix Weather app."
  type        = string
  sensitive   = true
}
