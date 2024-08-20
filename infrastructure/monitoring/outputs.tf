output "LOG_ANALYTICS_WORKSPACE_ID" {
  value     = azurerm_log_analytics_workspace.this.id
  sensitive = false
}

output "AZURE_MONITOR_ID" {
  value     = azurerm_monitor_workspace.this.id
  sensitive = false
}

output "AZURERM_MONITOR_DATA_COLLECTION_RULE_AZUREMONITOR_ID" {
  value     = azurerm_monitor_data_collection_rule.azuremonitor.id
  sensitive = false
}

output "AZURERM_MONITOR_DATA_COLLECTION_RULE_CONTAINER_INSIGHTS_ID" {
  value     = azurerm_monitor_data_collection_rule.container_insights.id
  sensitive = false
}

output "MONITORING_RESOURCE_GROUP_NAME" {
  value     = azurerm_resource_group.monitoring.name
  sensitive = false
}

output "MONITORING_LOCATION" {
  value     = azurerm_resource_group.monitoring.location
  sensitive = false
}

output "AI_CONNECTION_STRING" {
  value     = azurerm_application_insights.this.connection_string
  sensitive = true
}
