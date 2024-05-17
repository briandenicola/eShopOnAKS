Infrastructure
============
* The eShop infrastructure is deployed to Azure using Terraform.  
* The build process is kicked off using the command: `task up` command which kick start terraform.  
* Terraform will generate a random name that is used as the foundation for all the resources created in Azure.  The random name is generated using the `random_pet` and `random_integer` resources in Terraform.  This value should be saved as it is used throughout the deployment. The example name `bonefish-62420` is used in the rest of the documents
* The infrastructure deploy can take up to 30 minutes to complete.
* The infrastructure is deployed to a single Azure region (defaults to `westus3`) and consists of the following components:
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

Resource Groups
============
Name | Usage
------ | ----
Application Resource Group ("${app_name}_app_rg") | Used by components of the eShop application
Core Resource Group ("${app_name}_core_rg") | Core networking infrastructure
AKS Resource Group ("${app_name}_aks_rg")| Components required for AKS and Container Registry 
Monitoring Resource Group ("${app_name}_monitoring_rg")| AppInsights, Grafrana, Prometheus, and other monitoring components 
Chaos Resource Group ("${app_name}_chaos_rg") | Chaos Engineering components

> **Note**: All resource groups are tagged with the `Application="eShop On AKS"`
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

Networking
============
* A single Azure virtual network with a /16 address space is created in the Core Resource Group.
* A subnet for AKS named `nodes` is created in the virtual network with a /24 address space.
* A subnet for AKS's API  named `api-server` is created in the virtual network and delegated to `Microsoft.ContainerService/managedClusters`
* A subnet for all Private Endpoints named `private-endpoints` is created with a /24 address space.
* A delegated subnet for PostgreSQL named `sql` is created with a /24 address space and delegated to `Microsoft.DBforPostgreSQL/flexibleServers`
* The virtual network uses Azure DNS for name resolution and all Private DNS Zones required for the Azure resources private endpoints are linked to the virtual network.
* The eShop application will be accessible from the internet and by default has a Domain Name under `bjdazure.tech`. This is intially defined in the `DOMAIN_ROOT` variable in the `Taskfile.yaml` file.
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

AKS Cluster Components
============
* A managed AKS cluster is deployed to the AKS Resource Group with 2 node pools - one for system resources and one for user workloads.
* KeyVault CSI driver, Keda, and Azure Policy are enabled on the AKS cluster.
* The Flux operator is deployed to the AKS cluster to manage the deployment of post-deployment resources (see #GitOps below)
* The cluster is publically accessible but locked down to only allow traffic from your external IP address and requires Entra ID authentication for access
* An Azure container registry is deployed along side the AKS cluster to store the container images in the same resource group.
* Azure Service Mesh is installed as part of the cluster
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

GitOps
============
* The Flux operater is responsible for managing the deployment of additional components to the AKS cluster.
* Flux uses kustomize to apply the manifests in the `cluster-config` directory to the AKS cluster.
* Flux installs Cert-Manager to manage the certificates for the eShop application, Keda's HTTP Scaler, Kured for node reboots, and Kubecost for cost management.
* Flux also customizes Azure Service Mesh 
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

Monitoring
============
* Log Analytics Application Insights, Azure Managed Prometheus, and Grafana are deployed to the Monitoring Resource Group.
* All resources have their diagnostic settings enabled and are configured to send logs and metrics to Log Analytics.
* The AKS cluster is configured with Azure Managed Prometheus and Grafana for monitoring and visualization.
* Azure Monitor/Prometheus is deployed to the `westus2` region due to regional restrictions.
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

Redis
============
* Azure Redis Cache is deployed using the Premium SKU with a predefined capacity of 1 GB.
* It is deployed using Private Link and only accessible from the Azure virtual network.
* It is deployed into the Application Resource Group.
* The connection string used by the `basket-api` is stored in the Azure Key Vault under the secret named `redis_connection_string`.
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

PostgreSQL
============
* PostgreSQL is deployed using the `GP_Standard_D2ds_v4` Flex Server SKU in Azure. The vector extension has been added to the server post creation.  
* PostgreSQL is deployed into a delegated subnet and only accessible from the Azure virtual network.
* The databases `webhooksdb`, `cataglogdb`, `identitydb`, and `orderingdb` are created in the PostgreSQL server.  
* The connection string used by the appliation is stored in the Azure Key Vault under the secret named ${db_name}_connection_string. 
  * For example, the connection string for the catalog-api service is `catalogdb_connection_string`
* It is deployed into the Application Resource Group.  
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

Eventbus
============
* Eventbus is the only infrastructure component that is not a managed service in Azure.  T
* he Eventbus is a RabbitMQ cluster that is deployed to the AKS cluster.  The Eventbus is used for asynchronous communication between the microservices in the eShop application.  
* The Eventbus is deployed using the Helm chart along with the rest of the eShop application under charts/app.
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

# Example Setup
```pwsh
task apply
task: [apply] terraform -chdir=./infrastructure apply -auto-approve -var "region=westus3" -var "vm_size=Standard_D4ads_v5" -var "node_count=2" -var "tags=eShop On AKS" -compact-warnings
data.http.myip: Reading...
random_password.password: Refreshing state... [id=none]
random_integer.services_cidr: Refreshing state... [id=72]
random_integer.vnet_cidr: Refreshing state... [id=157]
random_integer.pod_cidr: Refreshing state... [id=117]
tls_private_key.rsa: Refreshing state... [id=8298f1606184149a208ca3684222a1cc6d2451eb]
random_pet.this: Refreshing state... [id=bonefish]
random_password.postgresql_user_password: Refreshing state... [id=none]
random_id.this: Refreshing state... [id=89Q]
data.http.myip: Read complete after 0s [id=http://checkip.amazonaws.com/]
data.azurerm_subscription.current: Reading...
azurerm_resource_group.app: Refreshing state... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_app_rg]
azurerm_resource_group.monitoring: Refreshing state... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_monitoring_rg]
azurerm_resource_group.aks: Refreshing state... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_aks_rg]
data.azurerm_client_config.current: Reading...
azurerm_resource_group.chaos: Refreshing state... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_chaos_rg]
azurerm_resource_group.core: Refreshing state... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_core_rg]
...
  # azurerm_resource_group.monitoring will be updated in-place
  ~ resource "azurerm_resource_group" "monitoring" {
        id       = "/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_monitoring_rg"
        name     = "bonefish-62420_monitoring_rg"
      ~ tags     = {
          - "AppName"     = "bonefish-62420"
          - "Application" = "eShop On AKS"
          - "DeployedOn"  = "2024-05-15T18:18:14Z"
          - "Tier"        = "Application Monitoring Components"
        } -> (known after apply)
        # (1 unchanged attribute hidden)
    }

Plan: 6 to add, 7 to change, 6 to destroy.
azurerm_monitor_data_collection_rule_association.this: Destroying... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_aks_rg/providers/Microsoft.ContainerService/managedClusters/bonefish-62420-aks/providers/Microsoft.Insights/dataCollectionRuleAssociations/bonefish-62420-ama-datacollection-rules-association]
azurerm_kubernetes_flux_configuration.flux_config: Destroying... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_aks_rg/providers/Microsoft.ContainerService/managedClusters/bonefish-62420-aks/providers/Microsoft.KubernetesConfiguration/fluxConfigurations/aks-flux-extension]
azurerm_resource_group.chaos: Modifying... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_chaos_rg]
azurerm_resource_group.app: Modifying... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_app_rg]
azurerm_monitor_diagnostic_setting.aks: Destroying... [id=/subscriptions/17e0b271-e92b-4c08-bf19-eb8be6c96991/resourceGroups/bonefish-62420_aks_rg/providers/Microsoft.ContainerService/managedClusters/bonefish-62420-aks|bonefish-62420-aks-diag]
...
azurerm_kubernetes_cluster.this: Still creating... [1m50s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m0s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m10s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m20s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m30s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m40s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [2m50s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m0s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m10s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m20s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m30s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m40s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [3m50s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [4m0s elapsed]
...
```
<p align="right">(<a href="#infrastructure">back to top</a>)</p>

### Resource Layout
TBD 

## Navigation

[Return to Main Index 🏠](../README.md) ‖
[Previous Section ⏪](./prerequisites.md) ‖ [Next Section ⏩](./build.md)
<p align="right">(<a href="#infrastructure">back to top</a>)</p>