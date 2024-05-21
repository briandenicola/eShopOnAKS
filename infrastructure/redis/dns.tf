
resource "azurerm_private_dns_zone" "privatelink_redis_cache_windows_net" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_redis_cache_windows_net" {
  name                  = "${var.vnet_name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_redis_cache_windows_net.name
  resource_group_name   = var.vnet_resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.this.id
}