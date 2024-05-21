variable "region" {
  description = "The location for this application deployment"
  default     = "westus3"
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}

variable "namespace" {
  description = "The namespace application will be deployed to"
  default     = "eshop"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "vm_size" {
  description = "The SKU for the default node pool"
  default     = "Standard_B4ms"
}

variable "node_count" {
  description = "The default number of nodes to scale the cluster to"
  type        = number
  default     = 1
}

variable "github_repo_branch" {
  description = "The branched used for Infrastructure GitOps"
  default     = "main"
}

variable "zones" {
  description = "The values for zones to deploy AKS nodes to"
  default     = ["1"]
}

variable "deploy_postgresql" {
  description = "Deploy Azure PostgreSQL as part of the infrastructure build"
  default     = true
}

variable "deploy_redis" {
  description = "Enable Azure Redis as part of the infrastructure build"
  default     = true
}

variable "deploy_openai" {
  description = "Enable Azure OpenAI as part of the infrastructure build"
  default     = false
}

variable "deploy_chaos" {
  description = "Enable Azure Chaos Studio as part of the infrastructure build"
  default     = true
}