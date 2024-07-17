data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.aks.location
}

locals {
  current_minus_2    = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 2]
  kubernetes_version = var.kubernetes_version == null ? local.current_minus_2 : var.kubernetes_version
  allowed_ip_range   = ["${chomp(data.http.myip.response_body)}/32"]
  zones              = var.region == "northcentralus" ? null : var.zones
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "this" {
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      kubernetes_version
    ]
  }

  depends_on = [
    azurerm_user_assigned_identity.aks_identity,
    azurerm_user_assigned_identity.aks_kubelet_identity,
    azurerm_role_assignment.aks_role_assignemnt_msi,
    azurerm_role_assignment.aks_role_assignemnt_nework
  ]

  name                         = local.aks_name
  resource_group_name          = azurerm_resource_group.aks.name
  location                     = azurerm_resource_group.aks.location
  node_resource_group          = "${local.aks_name}_nodes_rg"
  dns_prefix                   = local.aks_name
  sku_tier                     = "Standard"
  automatic_channel_upgrade    = "patch"
  node_os_channel_upgrade      = "NodeImage"
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true
  azure_policy_enabled         = true
  local_account_disabled       = false
  open_service_mesh_enabled    = false
  run_command_enabled          = false
  kubernetes_version           = local.kubernetes_version
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = data.azurerm_subnet.api.id
    authorized_ip_ranges     = local.allowed_ip_range
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  linux_profile {
    admin_username = "manager"
    ssh_key {
      key_data = tls_private_key.rsa.public_key_openssh
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
  }

  default_node_pool {
    name                         = "system"
    node_count                   = 1
    vm_size                      = var.system_vm_size
    zones                        = local.zones
    os_disk_size_gb              = 127
    vnet_subnet_id               = data.azurerm_subnet.kubernetes.id
    os_sku                       = "Mariner"
    type                         = "VirtualMachineScaleSets"
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 250
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "rotation"
    upgrade_settings {
      max_surge                  = "33%"
      drain_timeout_in_minutes   = 5
    }
  }

  network_profile {
    dns_service_ip      = "100.${random_integer.services_cidr.id}.0.10"
    service_cidr        = "100.${random_integer.services_cidr.id}.0.0/16"
    pod_cidr            = "100.${random_integer.pod_cidr.id}.0.0/16"
    network_plugin      = "cilium"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    network_data_plane  = "cilium"
  }

  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Friday"
    utc_offset  = "-06:00"
    start_time  = "20:00"
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Saturday"
    utc_offset  = "-06:00"
    start_time  = "20:00"
  }

  auto_scaler_profile {
    max_unready_nodes = "1"
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = var.azurerm_log_analytics_workspace_id
  }

  microsoft_defender {
    log_analytics_workspace_id = var.azurerm_log_analytics_workspace_id
  }

  monitor_metrics {
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  service_mesh_profile {
    mode                             = "Istio"
    external_ingress_gateway_enabled = true
  }

  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
  }

}

