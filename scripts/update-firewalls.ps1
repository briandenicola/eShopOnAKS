#!/usr/bin/pwsh

[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
  [Parameter(ParameterSetName = 'Default', Mandatory = $true)]
  [string] $AppName,

  [Parameter(ParameterSetName = 'Default', Mandatory = $true)]
  [string] $SubscriptionName
)

. ./modules/eshop_functions.ps1
. ./modules/eshop_naming.ps1 -AppName $AppName

#Connect to Azure and Log into ACR
Connect-ToAzure -SubscriptionName $SubscriptionName

$my_ip = $(curl -sS http://checkip.amazonaws.com/)
$chaos_ip = $(az network list-service-tags --location westus --query "values[?name=='ChaosStudio'].properties.addressPrefixes" -o tsv)

Write-Host "Updating Azure Container Registry ($AKS_RG_NAME/$APP_ACR_NAME) firewall to allow access from $my_ip"
az acr network-rule add --name $APP_ACR_NAME --resource-group ${AKS_RG_NAME} --ip-address $my_ip

Write-Host "Updating KeyVault ($APP_RG_NAME/$APP_KV_NAME) firewall to allow access from $ip"
az keyvault network-rule add --name $APP_KV_NAME --resource-group ${APP_RG_NAME} --ip-address $my_ip

Write-Host  "Updating AKS ($AKS_RG_NAME/$APP_K8S_NAME) firewall to allow access from $my_ip and Chaos Engineering IPs"
az aks update -n $APP_K8S_NAME -g $AKS_RG_NAME --api-server-authorized-ip-ranges ("{0}/32,{1}" -f $my_ip, $chaos_ip.Replace("`t", ","))