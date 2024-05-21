resource "random_password" "postgresql_user_password" {
  length  = 25
  special = false
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = local.sql_name
  resource_group_name    = var.sql_resource_group_name
  location               = var.region
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.id
  version                = "15"
  administrator_login    = var.postgresql_user_name
  administrator_password = random_password.postgresql_user_password.result
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2ds_v4"
  zone                   = "2"
}

resource "azapi_update_resource" "azurerm_postgresql_configuration_vector_enable" {
  type        = "Microsoft.DBforPostgreSQL/flexibleServers/configurations@2023-03-01-preview"
  resource_id = "${azurerm_postgresql_flexible_server.this.id}/configurations/azure.extensions"

  body = jsonencode({
    properties = {
      source = "user-override"
      value  = "vector"
    }
  })
}

