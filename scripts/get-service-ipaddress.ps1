#!/usr/bin/pwsh

[CmdletBinding(DefaultParameterSetName = 'Default')]
param()

$IP=$(kubectl --namespace aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
Write-Host ${IP}