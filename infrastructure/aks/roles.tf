resource "azurerm_role_assignment" "aks_role_assignemnt_nework" {
  scope                            = data.azurerm_virtual_network.this.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_role_assignemnt_msi" {
  scope                            = azurerm_user_assigned_identity.aks_kubelet_identity.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                            = azurerm_container_registry.this.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "istio_ingress_secret_access" {
  scope                            = var.keyvault_id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_user_assigned_identity.aks_service_mesh_identity.principal_id
  skip_service_principal_aad_check = true
}