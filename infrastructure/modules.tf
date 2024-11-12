module "core" {
  source                        = "./core"
  region                        = var.region
  app_name                      = local.resource_name
  tags                          = var.tags
}

module "keyvault" {
  depends_on = [
    module.core
  ]
  source                       = "./keyvault"
  region                       = var.region
  app_name                     = local.resource_name
  keyvault_resource_group_name = azurerm_resource_group.app.name
  vnet_name                    = module.core.VNET_NAME
  vnet_resource_group_name     = module.core.CORE_RESOURCE_GROUP
  private_endpoint_subnet_id   = module.core.PE_SUBNET_ID
}

module "monitoring" {
  depends_on = [
    module.core
  ]
  source                       = "./monitoring"
  core_region                  = var.region
  app_name                     = local.resource_name
  tags                         = var.tags
  app_identity_principal_id    = azurerm_user_assigned_identity.app_identity.principal_id
}

module "aks" {
  depends_on = [
    module.core,
    module.keyvault,
    module.monitoring
  ]
  source                                                                  = "./aks"
  region                                                                  = var.region
  zones                                                                   = local.zones
  app_name                                                                = local.resource_name
  tags                                                                    = var.tags
  kubernetes_version                                                      = var.kubernetes_version
  istio_version                                                           = var.istio_version
  vm_size                                                                 = var.vm_size
  system_vm_size                                                          = var.vm_size
  node_count                                                              = var.node_count
  vnet_name                                                               = module.core.VNET_NAME
  vnet_resource_group_name                                                = module.core.CORE_RESOURCE_GROUP
  keyvault_id                                                             = module.keyvault.KEYVAULT_RESOURCE_ID
  azurerm_log_analytics_workspace_id                                      = module.monitoring.LOG_ANALYTICS_WORKSPACE_ID
  azurerm_monitor_data_collection_rule_azuremonitor_id                    = module.monitoring.AZURERM_MONITOR_DATA_COLLECTION_RULE_AZUREMONITOR_ID
  azurerm_monitor_container_insights_data_collection_rule_azuremonitor_id = module.monitoring.AZURERM_MONITOR_DATA_COLLECTION_RULE_CONTAINER_INSIGHTS_ID
  private_endpoint_subnet_id                                              = module.core.PE_SUBNET_ID
}

module "sql" {
  depends_on = [
    module.core,
    module.keyvault,
    module.monitoring
  ]
  count                      = var.deploy_postgresql ? 1 : 0
  source                     = "./sql"
  region                     = var.region
  zones                      = local.sql_zone
  app_name                   = local.resource_name
  sql_resource_group_name    = azurerm_resource_group.app.name
  vnet_name                  = module.core.VNET_NAME
  vnet_resource_group_name   = module.core.CORE_RESOURCE_GROUP
  subnet_id                  = module.core.SQL_SUBNET_ID
  log_analytics_workspace_id = module.monitoring.LOG_ANALYTICS_WORKSPACE_ID
  keyvault_id                = module.keyvault.KEYVAULT_RESOURCE_ID
}

module "redis" {
  depends_on = [
    module.core,
    module.keyvault,
    module.monitoring
  ]
  count                      = var.deploy_redis ? 1 : 0
  source                     = "./redis"
  region                     = var.region
  app_name                   = local.resource_name
  redis_resource_group_name  = azurerm_resource_group.app.name
  vnet_name                  = module.core.VNET_NAME
  vnet_resource_group_name   = module.core.CORE_RESOURCE_GROUP
  private_endpoint_subnet_id = module.core.PE_SUBNET_ID
  log_analytics_workspace_id = module.monitoring.LOG_ANALYTICS_WORKSPACE_ID
  keyvault_id                = module.keyvault.KEYVAULT_RESOURCE_ID
  zones                      = local.zones
}

module "chaos" {
  depends_on = [
    module.core
  ]
  count    = var.deploy_chaos ? 1 : 0
  source   = "./chaos"
  region   = var.region
  app_name = local.resource_name
  tags     = var.tags
}
