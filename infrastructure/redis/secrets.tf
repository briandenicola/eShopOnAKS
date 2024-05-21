resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redis-connection-string"
  value        = azurerm_redis_cache.this.primary_connection_string
  key_vault_id = var.keyvault_id
}