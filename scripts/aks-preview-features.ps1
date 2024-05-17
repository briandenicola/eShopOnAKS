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

Write-Host "Run: az feature list --namespace Microsoft.ContainerService -o table --query `"[?properties.state == `'Registering`']`""
Write-Host "When there are no more features still registering then run:"
Write-Host "az provider register --namespace Microsoft.Kubernetes"
Write-Host "az provider register --namespace Microsoft.ContainerService"
Write-Host "az provider register --namespace Microsoft.KubernetesConfiguration"