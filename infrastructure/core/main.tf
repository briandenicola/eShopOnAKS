resource "random_integer" "vnet_cidr" {
  min = 25
  max = 250
}

locals {
  resource_name    = var.app_name
  vnet_name        = "${local.resource_name}-vnet"
  vnet_cidr        = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidr   = cidrsubnet(local.vnet_cidr, 8, 1)
  sql_subnet_cidr  = cidrsubnet(local.vnet_cidr, 8, 2)
  api_subnet_cidir = cidrsubnet(local.vnet_cidr, 8, 3)
  k8s_subnet_cidr  = cidrsubnet(local.vnet_cidr, 8, 4)
}
