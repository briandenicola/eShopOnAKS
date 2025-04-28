locals {
  resource_name = var.app_name
  redis_name    = "${local.resource_name}-cache"
}
