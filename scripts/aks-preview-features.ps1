#!/usr/bin/pwsh

[CmdletBinding(DefaultParameterSetName = 'Default')]
param()

az extension add --name aks-preview
az extension add --name k8s-extension
az extension update --name aks-preview

$features=@(
    "AKS-ExtensionManager",
    "AKS-PrometheusAddonPreview",
    "EnableImageCleanerPreview",
    "AKS-KedaPreview",
    "EnableAPIServerVnetIntegrationPreview",
    "TrustedAccessPreview",
    "NetworkObservabilityPreview",
    "AKS-AzurePolicyExternalData"
)

foreach($feature in $features) {
    az feature register --namespace Microsoft.ContainerService --name $feature
}

watch -n 10 -g az feature list --namespace Microsoft.ContainerService -o table --query \"[?properties.state == \'Registering\']\"
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.Monitor
az provider register --namespace Microsoft.Dashboard
az provider register --namespace Microsoft.AlertsManagement