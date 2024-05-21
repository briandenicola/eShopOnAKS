output "KEYVAULT_RESOURCE_ID" {
  value     = azurerm_key_vault.this.id
  sensitive = false
}

output "KEYVAULT_NAME" {
  value = azurerm_key_vault.this.name
}
