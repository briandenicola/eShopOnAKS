resource "azurerm_role_assignment" "deployer_kv_access" {
  scope                            = azurerm_key_vault.this.id
  role_definition_name             = "Key Vault Administrator"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

