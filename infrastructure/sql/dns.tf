resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_postgres_database_azure_com" {
  name                  = "${var.vnet_name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.name
  resource_group_name   = var.vnet_resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}
