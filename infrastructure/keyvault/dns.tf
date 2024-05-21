
resource "azurerm_private_dns_zone" "privatelink_vaultcore_azure_net" {
  name                      = "privatelink.vaultcore.azure.net"
  resource_group_name       = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_vaultcore_azure_net" {
  name                      = "${var.vnet_name}-link"
  private_dns_zone_name     = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  resource_group_name       = var.vnet_resource_group_name
  virtual_network_id        = data.azurerm_virtual_network.this.id
}

