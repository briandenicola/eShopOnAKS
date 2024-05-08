[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $AppName,
  
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $SubscriptionName,

    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $DomainName
)

. ./modules/eshop_functions.ps1
. ./modules/eshop_naming.ps1 -AppName $AppName -DomainName $DomainName

Connect-ToAzure -SubscriptionName $SubscriptionName
Get-AKSCredentials -AKSName $APP_K8S_NAME -AKSResourceGroup $CORE_RG_NAME

# Determine all required parameters
$commit_version = "ced7164c" #Get-GitCommitVersion -Source "."
$app_insights_key = Get-AppInsightsKey -AppInsightsAccountName $APP_AI_NAME -AppInsightsResourceGroup $CORE_RG_NAME
$app_msi  = Get-MSIAccountInfo -MSIName $APP_SERVICE_ACCT -MSIResourceGroup $CORE_RG_NAME
$eventubs_password = New-Password -Length 30

# Install App using Helm Chart
Write-Log -Message "Deploying ${CHART_NAME} to ${commit_version}"
helm upgrade -i ${CHART_NAME} `
    --set APP_NAME=$AppName `
    --set NAMESPACE=$APP_NAMESPACE `
    --set GIT_COMMIT_VERSION=$commit_version `
    --set WORKLOAD_ID.CLIENT_ID=$($app_msi.client_id) `
    --set WORKLOAD_ID.TENANT_ID=$($app_msi.tenant_id) `
    --set WORKLOAD_ID.NAME=$APP_SERVICE_ACCT `
    --set KEYVAULT.NAME=$APP_KV_NAME `
    --set EVENTBUS.PASSWORD=$eventubs_password `
    --set ACR.NAME=$APP_ACR_NAME `
    --set REGION=$($cogs.region) `
    --set APP_INSIGHTS.CONNECTION_STRING=$($app_insights_key.connection_string) `
    --set ISTIO.GATEWAY=$APP_ISTIO_GATEWAY `
    --set ISTIO.IDENTITY.EXTERNAL_URL="$APP_IDENTITY_URL" `
    --set ISTIO.WEBAPP.EXTERNAL_URL="$APP_URL" `
    ../chart/.

if($?){
    Write-Log "Application successfully deployed. . ."
}
else {
    Write-Log ("Errors encountered while deploying application. Please review. Application Name: {0}" -f $AppName )
} 