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