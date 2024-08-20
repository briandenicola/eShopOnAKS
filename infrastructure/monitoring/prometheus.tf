resource "azurerm_monitor_workspace" "this" {
  name                = local.azuremonitor_workspace_name
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${local.resource_name}-ama-datacollection-ep"
  resource_group_name           = azurerm_resource_group.monitoring.name
  location                      = azurerm_resource_group.monitoring.location
  kind                          = "Linux"
  public_network_access_enabled = true
}