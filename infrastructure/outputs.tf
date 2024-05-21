output "APP_NAME" {
  value     = local.resource_name
  sensitive = false
}

output "APP_RESOURCE_GROUP" {
  value     = azurerm_resource_group.app.name
  sensitive = false
}

output "ACR_NAME" {
  value     = module.aks.ACR_NAME
  sensitive = false
}

output "AKS_CLUSTER_NAME" {
  value     = module.aks.AKS_CLUSTER_NAME
  sensitive = false
}

output "AKS_RESOURCE_GROUP" {
  value     = module.aks.AKS_RESOURCE_GROUP
  sensitive = false
}

output "INGRESS_CLIENT_ID" {
  value = module.aks.INGRESS_CLIENT_ID
}

output "CHAOS_RESOURCE_GROUP" {  
  value     = module.chaos[0].CHAOS_RESOURCE_GROUP_NAME
  sensitive = false
}

output "CHAOS_RESOURCE_LOCATION" {
  value     = module.chaos[0].CHAOS_RESOURCE_GROUP_LOCATION
  sensitive = false
}

output "ARM_TENANT_ID" {
  value     = data.azurerm_client_config.current.tenant_id
  sensitive = false
}

output "ARM_WORKLOAD_APP_ID" {
  value     = azurerm_user_assigned_identity.app_identity.client_id
  sensitive = false
}
output "AI_CONNECTION_STRING" {
    value = module.monitoring.AI_CONNECTION_STRING
    sensitive = true
}

output "KEYVAULT_NAME" {
    value = module.keyvault.KEYVAULT_NAME
}
