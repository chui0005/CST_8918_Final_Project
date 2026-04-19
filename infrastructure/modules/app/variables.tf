variable "app_name" {
  description = "Name of the Kubernetes deployment and service."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy the app into."
  type        = string
}

variable "image" {
  description = "Fully qualified container image reference (e.g. myacr.azurecr.io/weather:abc123)."
  type        = string
}

variable "redis_host" {
  description = "Hostname of the Azure Cache for Redis instance."
  type        = string
}

variable "redis_port" {
  description = "SSL port of the Azure Cache for Redis instance (6380)."
  type        = number
}

variable "weather_api_key" {
  description = "OpenWeather API key injected as a Kubernetes Secret."
  type        = string
  sensitive   = true
}

variable "redis_password" {
  description = "Primary access key for the Redis Cache, injected as a Kubernetes Secret."
  type        = string
  sensitive   = true
}

variable "replicas" {
  description = "Number of pod replicas for the deployment."
  type        = number
  default     = 1
}
