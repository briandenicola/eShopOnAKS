resource "azurerm_key_vault_secret" "redis_connection_string" {
  depends_on = [
    azurerm_role_assignment.deployer_kv_access
  ]
  name         = "redis-connection-string"
  value        = azurerm_redis_cache.this.primary_connection_string
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "catalogdb_connection_string" {
  depends_on = [
    azurerm_role_assignment.deployer_kv_access
  ]
  name         = "catalogdb-connection-string"
  value        = "Host=${local.sql_name}.postgres.database.azure.com; Username=${var.postgresql_user_name};Password=${random_password.postgresql_user_password.result};Port=5432;Database=catalogdb;Sslmode=require"
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "identitydb_connection_string" {
  depends_on = [
    azurerm_role_assignment.deployer_kv_access
  ]
  name         = "identitydb-connection-string"
  value        = "Host=${local.sql_name}.postgres.database.azure.com; Username=${var.postgresql_user_name};Password=${random_password.postgresql_user_password.result};Port=5432;Database=identitydb;Sslmode=require"
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "orderingdb_connection_string" {
  depends_on = [
    azurerm_role_assignment.deployer_kv_access
  ]
  name         = "orderingdb-connection-string"
  value        = "Host=${local.sql_name}.postgres.database.azure.com; Username=${var.postgresql_user_name};Password=${random_password.postgresql_user_password.result};Port=5432;Database=orderingdb;Sslmode=require"
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "webhooksdb_connection_string" {
  depends_on = [
    azurerm_role_assignment.deployer_kv_access
  ]
  name         = "webhooksdb-connection-string"
  value        = "Host=${local.sql_name}.postgres.database.azure.com; Username=${var.postgresql_user_name};Password=${random_password.postgresql_user_password.result};Port=5432;Database=webhooksdb;Sslmode=require"
  key_vault_id = azurerm_key_vault.this.id
}
