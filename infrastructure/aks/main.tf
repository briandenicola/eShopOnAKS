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
  resource_name             = var.app_name
  aks_name                  = "${local.resource_name}-aks"
  acr_name                  = "${replace(local.resource_name, "-", "")}containers"
  aks_service_mesh_identity = "${local.aks_name}-${var.service_mesh_type}-pod-identity"
  istio_cfg_path            = "./cluster-config/istio/configuration"
  istio_gw_path             = "./cluster-config/istio/gateway"
  app_path                  = "./cluster-config"
  flux_repository           = "https://github.com/briandenicola/eshoponaks"

}
