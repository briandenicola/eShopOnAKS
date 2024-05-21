resource "random_password" "password" {
  length  = 25
  special = true
}

locals {
  resource_name = var.app_name
  sql_name      = "${local.resource_name}-sql"
}
