data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_password" "password" {
  length  = 25
  special = true
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

resource "random_integer" "services_cidr" {
  min = 64
  max = 99
}

resource "random_integer" "pod_cidr" {
  min = 100
  max = 127
}

locals {
  resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                    = "${local.resource_name}-aks"
  kv_name                     = "${local.resource_name}-kv"
  azuremonitor_workspace_name = "${local.resource_name}-logs"
  ai_name                     = "${local.resource_name}-appinsights"
  redis_name                  = "${local.resource_name}-cache"
  la_name                     = "${local.resource_name}-logs"
  vnet_name                   = "${local.resource_name}-vnet"
  acr_name                    = "${replace(local.resource_name, "-", "")}containers"
  sql_name                    = "${local.resource_name}-sql"
  openai_name                 = "${local.resource_name}-openai"
  aks_service_mesh_identity   = "${local.aks_name}-${var.service_mesh_type}-pod-identity"
  istio_cfg_path              = "./cluster-config/istio/configuration"
  istio_gw_path               = "./cluster-config/istio/gateway"
  app_path                    = "./cluster-config"
  flux_repository             = "https://github.com/briandenicola/eshoponaks"
  vnet_cidr                   = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidr              = cidrsubnet(local.vnet_cidr, 8, 1)
  sql_subnet_cidr             = cidrsubnet(local.vnet_cidr, 8, 2)
  api_subnet_cidir            = cidrsubnet(local.vnet_cidr, 8, 3)
  k8s_subnet_cidr             = cidrsubnet(local.vnet_cidr, 8, 4)
}