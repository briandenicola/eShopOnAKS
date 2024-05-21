output "REDIS_RESOURCE_ID" {
  value     = azurerm_redis_cache.this.id
  sensitive = false
}

output "REDIS_NAME" {
  value = azurerm_redis_cache.this.id
}
