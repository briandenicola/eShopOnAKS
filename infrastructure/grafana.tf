resource "azurerm_dashboard_grafana" "this" {
  depends_on = [
    azurerm_monitor_workspace.this
  ]

  name                              = "${local.resource_name}-grafana"
  resource_group_name               = azurerm_resource_group.monitoring.name
  location                          = azurerm_resource_group.core.location
  sku                               = "Standard"
  zone_redundancy_enabled           = false
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this.id
  }
}