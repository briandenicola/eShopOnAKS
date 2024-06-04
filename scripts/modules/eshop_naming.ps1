Set-Variable -Name cwd                  -Value $PWD.Path
Set-Variable -Name root                 -Value (Get-Item $PWD.Path).Parent.FullName
Set-Variable -Name UriFriendlyAppName   -Value $AppName.Replace("-","")                 -Option Constant

Set-Variable -Name AKS_RG_NAME          -Value ("{0}_aks_rg" -f $AppName)               -Option Constant
Set-Variable -Name CORE_RG_NAME         -Value ("{0}_core_rg" -f $AppName)              -Option Constant
Set-Variable -Name APP_RG_NAME          -Value ("{0}_app_rg" -f $AppName)               -Option Constant
Set-Variable -Name MONITORING_RG_NAME   -Value ("{0}_monitoring_rg" -f $AppName)        -Option Constant

Set-Variable -Name APP_K8S_NAME         -Value ("{0}-aks" -f $AppName)                  -Option Constant
Set-Variable -Name APP_ACR_NAME         -Value ("{0}containers" -f $UriFriendlyAppName) -Option Constant
Set-Variable -Name APP_KV_NAME          -Value ("{0}-kv" -f $AppName)                   -Option Constant
Set-Variable -Name APP_CACHE_NAME       -Value ("{0}-cache" -f $AppName)                -Option Constant
Set-Variable -Name APP_SQL_NAME         -Value ("{0}-sql" -f $AppName)                  -Option Constant
Set-Variable -Name APP_SA_NAME          -Value ("{0}files" -f $UriFriendlyAppName)      -Option Constant
Set-Variable -Name APP_SERVICE_ACCT     -Value ("{0}-app-identity" -f $AppName)         -Option Constant
Set-Variable -Name APP_AI_NAME          -Value ("{0}-appinsights" -f $AppName)          -Option Constant
Set-Variable -Name APP_NAMESPACE        -Value "eshop"                                  -Option Constant
Set-Variable -Name INFRA_NAMESPACE      -Value "eshop-infra"                            -Option Constant
Set-Variable -Name CHART_NAME           -Value "eshop"                                  -Option Constant
Set-Variable -Name CERT_CHART_NAME      -Value "eshop-certificate"                      -Option Constant
Set-Variable -Name INFRA_CHART_NAME     -Value "eshop-infra-components"                 -Option Constant

Set-Variable -Name APP_ISTIO_GATEWAY    -Value "aks-istio-ingress/istio-ingressgateway"         -Option Constant
Set-Variable -Name APP_IDENTITY_URL     -Value ("identity.{0}.{1}" -f $AppName,$DomainName)     -Option Constant
Set-Variable -Name APP_URL              -Value ("shop.{0}.{1}" -f $AppName,$DomainName)         -Option Constant

Set-Variable -Name Services             -Value @(
    @{Name="basket-api"; Path="src/Basket.API"},
    @{Name="catalog-api"; Path="src/Catalog.API"},
    @{Name="identity-api"; Path="src/Identity.API"},
    @{Name="mobile-bff"; Path="src/Mobile.Bff.Shopping"},
    @{Name="order-processor"; Path="src/OrderProcessor"},
    @{Name="ordering-api"; Path="src/Ordering.API"},
    @{Name="payment-processor"; Path="src/PaymentProcessor"},
    @{Name="webapp"; Path="src/WebApp"},
    @{Name="webhooks-api"; Path="src/Webhooks.API"},
    @{Name="webhooksclient"; Path="src/WebhookClient"}
) -Option Constant