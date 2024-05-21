output "SQL_RESOURCE_ID" {
  value     = azurerm_postgresql_flexible_server.this.id
  sensitive = false
}

output "SQL_NAME" {
  value = azurerm_postgresql_flexible_server.this
  sensitive = false
}