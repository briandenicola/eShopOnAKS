locals {
  resource_name = var.app_name
  kv_name       = "${local.resource_name}-kv"
}