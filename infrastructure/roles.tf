
resource "azurerm_role_assignment" "secrets" {
  scope                            = module.keyvault.KEYVAULT_RESOURCE_ID
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_user_assigned_identity.app_identity.principal_id
  skip_service_principal_aad_check = true
}