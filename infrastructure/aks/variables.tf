variable "region" {
  description = "The location for this application deployment"
  default     = "westus3"
}

variable "app_name" {
  description = "The root name for this application deployment"
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}

variable "namespace" {
  description = "The namespace application will be deployed to"
  default     = "eshop"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the AKS cluster"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "vm_size" {
  description = "The SKU for the default node pool"
  default     = "Standard_B4ms"
}

variable "system_vm_size" {
  description = "The SKU for the default node pool"
  default     = "Standard_B4ms"
}

variable "node_count" {
  description = "The default number of nodes to scale the cluster to"
  type        = number
  default     = 1
}

variable "vnet_name" {
  description = "The name of the VNet to attach to"
}

variable "vnet_resource_group_name" {
  description = "The name of the Resource Group for the VNet"
}

variable "subnet_id" {
  description = "The name of the Subnet to attach to"
}

variable "github_repo_branch" {
  description = "The branched used for Infrastructure GitOps"
  default     = "main"
}

variable "zones" {
  description = "The values for zones to deploy AKS nodes to"
  default     = ["1"]
}

variable "keyvault_id" {
  description = "The Resource ID of the KeyVault"
}

variable "azurerm_log_analytics_workspace_id" {
  description = "The Resource ID of the Log Analytics"
}

variable "azurerm_monitor_data_collection_rule_azuremonitor_id" {
  description = "The Resource ID of the Azure Monitor Data Collection Rule"
}

variable "monitoring_resource_group_name" {
  description = "The name of the Resource Group for the Monitoring"
}

variable "monitoring_location" {
  description = "The location of the Resource Group for the Monitoring"
}

variable "azure_monitor_id" {
  description = "The Resource ID of the Azure Monitor"
}