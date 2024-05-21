resource "azurerm_monitor_data_collection_rule_association" "this" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id = var.azurerm_monitor_data_collection_rule_azuremonitor_id
}
