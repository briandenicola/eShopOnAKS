locals {
  workload_identity = "${local.resource_name}-app-identity"
}

resource "azurerm_user_assigned_identity" "app_identity" {
  name                = local.workload_identity
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
}

resource "azurerm_federated_identity_credential" "app_identity" {
  name                = local.workload_identity
  resource_group_name = azurerm_resource_group.app.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.AKS_OIDC_ISSUER_URL
  parent_id           = azurerm_user_assigned_identity.app_identity.id
  subject             = "system:serviceaccount:${var.namespace}:${local.workload_identity}"
}