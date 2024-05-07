resource "random_password" "postgresql_user_password" {
  length           = 25
  special          = false
}

resource "azurerm_postgresql_flexible_server" "this" {
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.privatelink_postgres_database_azure_com
  ]
  name                   = local.sql_name
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  delegated_subnet_id    = azurerm_subnet.sql.id
  private_dns_zone_id    = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.id
  version                = "15"
  administrator_login    = var.postgresql_user_name
  administrator_password = random_password.postgresql_user_password.result
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2ds_v4"
  zone                   = "2"
}

resource "azapi_update_resource" "azurerm_postgresql_configuration_vector_enable" {
  type = "Microsoft.DBforPostgreSQL/flexibleServers/configurations@2023-03-01-preview"
  resource_id  = "${azurerm_postgresql_flexible_server.this.id}/configurations/azure.extensions"

  body = jsonencode({
    properties = {
      source = "user-override"
      value = "vector"
    }
  })
}

resource "azurerm_postgresql_flexible_server_database" "eshop_webhooksdb" {
  name                   = "webhooksdb"
  server_id              = azurerm_postgresql_flexible_server.this.id
  collation              = "en_US.utf8"
  charset                = "utf8"
}

resource "azurerm_postgresql_flexible_server_database" "eshop_catalogdb" {
  name                   = "catalogdb"
  server_id              = azurerm_postgresql_flexible_server.this.id
  collation              = "en_US.utf8"
  charset                = "utf8"
}

resource "azurerm_postgresql_flexible_server_database" "eshop_identitydb" {
  name                   = "identitydb"
  server_id              = azurerm_postgresql_flexible_server.this.id
  collation              = "en_US.utf8"
  charset                = "utf8"
}

resource "azurerm_postgresql_flexible_server_database" "eshop_orderingdb" {
  name                   = "orderingdb"
  server_id              = azurerm_postgresql_flexible_server.this.id
  collation              = "en_US.utf8"
  charset                = "utf8"
}
