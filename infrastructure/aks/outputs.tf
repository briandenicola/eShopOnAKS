
output "ACR_NAME" {
  value     = azurerm_container_registry.this.name
  sensitive = false
}

output "AKS_CLUSTER_NAME" {
  value     = azurerm_kubernetes_cluster.this.name
  sensitive = false
}

output "AKS_RESOURCE_GROUP" {
  value     = azurerm_kubernetes_cluster.this.resource_group_name
  sensitive = false
}

output "ARM_TENANT_ID" {
  value     = data.azurerm_client_config.current.tenant_id
  sensitive = false
}

output "INGRESS_CLIENT_ID" {
  value = azurerm_user_assigned_identity.aks_service_mesh_identity.client_id
}

output "AKS_OIDC_ISSUER_URL" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}
