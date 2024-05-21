resource "azurerm_private_dns_zone" "privatelink_azurecr_io" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_azurecr_io" {
  name                  = "${var.vnet_name}-acr-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurecr_io.name
  resource_group_name   = var.vnet_resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.this.id
}