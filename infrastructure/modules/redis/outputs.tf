output "redis_name" {
  description = "Name of the Redis Cache instance."
  value       = azurerm_redis_cache.main.name
}

output "redis_hostname" {
  description = "Hostname of the Redis Cache."
  value       = azurerm_redis_cache.main.hostname
}

output "redis_ssl_port" {
  description = "SSL port of the Redis Cache (6380)."
  value       = azurerm_redis_cache.main.ssl_port
}

output "primary_access_key" {
  description = "Primary access key for the Redis Cache."
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}
