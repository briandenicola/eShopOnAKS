locals {
  connection_string_template = "Host=${local.sql_name}.postgres.database.azure.com; Username=${var.postgresql_user_name};Password=${random_password.postgresql_user_password.result};Port=5432;Sslmode=require"
}

resource "azurerm_key_vault_secret" "catalogdb_connection_string" {
  name         = "catalogdb-connection-string"
  value        = "${local.connection_string_template};Database=catalogdb"
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "identitydb_connection_string" {
  name         = "identitydb-connection-string"
  value        = "${local.connection_string_template};Database=identitydb"
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "orderingdb_connection_string" {
  name         = "orderingdb-connection-string"
  value        = "${local.connection_string_template};Database=orderingdb"
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "webhooksdb_connection_string" {
  name         = "webhooksdb-connection-string"
  value        = "${local.connection_string_template};Database=webhooksdb"
  key_vault_id = var.keyvault_id
}
