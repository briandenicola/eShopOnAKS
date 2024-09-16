resource "azurerm_redis_cache" "this" {
  name                 = local.redis_name
  resource_group_name  = var.redis_resource_group_name
  location             = var.region
  capacity             = 1
  family               = "P"
  sku_name             = "Premium"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  redis_configuration {
  }
}

resource "azurerm_monitor_diagnostic_setting" "redis" {
  name                       = "diag"
  target_resource_id         = azurerm_redis_cache.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_private_endpoint" "redis_account" {
  name                = "${local.redis_name}-ep"
  resource_group_name = var.redis_resource_group_name
  location            = var.region
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.redis_name}-ep"
    private_connection_resource_id = azurerm_redis_cache.this.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_redis_cache_windows_net.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_redis_cache_windows_net.id]
  }
}
