resource "azurerm_monitor_data_collection_rule_association" "prometheus" {
  name                    = "${local.resource_name}-ama-prometheus-rules-association"
  target_resource_id      = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id = var.azurerm_monitor_data_collection_rule_azuremonitor_id
}

resource "azurerm_monitor_data_collection_rule_association" "container_insights" {
  name                        = "${local.resource_name}-ama-container-insights-rules-association"
  target_resource_id          = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id     = var.azurerm_monitor_container_insights_data_collection_rule_azuremonitor_id
}
