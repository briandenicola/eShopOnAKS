resource "azurerm_log_analytics_workspace" "this" {
  name                          = local.la_name
  location                      = azurerm_resource_group.monitoring.location
  resource_group_name           = azurerm_resource_group.monitoring.name
  sku                           = "PerGB2018"
  daily_quota_gb                = 1
}

resource "azurerm_application_insights" "this" {
  name                          = local.ai_name
  location                      = azurerm_resource_group.monitoring.location
  resource_group_name           = azurerm_resource_group.monitoring.name
  workspace_id                  = azurerm_log_analytics_workspace.this.id
  application_type              = "web"
}
