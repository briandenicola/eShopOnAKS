[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $AppName,
  
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $SubscriptionName,

    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $DomainName

)

. ./modules/traduire_functions.ps1
. ./modules/traduire_naming.ps1 -AppName $AppName

Connect-ToAzure -SubscriptionName $SubscriptionName
Get-AKSCredentials -AKSName $APP_K8S_NAME -AKSResourceGroup $APP_RG_NAME

# Determine all required parameters
$commit_version = Get-GitCommitVersion -Source $SourceRootDirectory
$app_insights_key = Get-AppInsightsKey -AppInsightsAccountName $APP_AI_NAME -AppInsightsResourceGroup $APP_RG_NAME
$app_msi  = Get-MSIAccountInfo -MSIName $APP_SERVICE_ACCT -MSIResourceGroup $APP_RG_NAME

# Install App using Helm Chart
Write-Log -Message "Deploying ${CHART_NAME} to ${commit_version}"
helm upgrade -i ${CHART_NAME} ../chart/. `
    --set APP_NAME=$AppName `
    --set NAMESPACE=$APP_NAMESPACE `
    --set GIT_COMMIT_VERSION=$commit_version `
    --set WORKLOAD_ID.CLIENT_ID=$($app_msi.client_id) `
    --set WORKLOAD_ID.TENANT_ID=$($app_msi.tenant_id) `
    --set WORKLOAD_ID.NAME=$APP_SERVICE_ACCT `
    --set KEYVAULT.NAME=$APP_KV_NAME `
    --set ACR.NAME=$APP_ACR_NAME `
    --set REGION=$($cogs.region) `
    --set APP_INSIGHTS.CONNECTION_STRING=$($app_insights_key.connection_string) `

if($?){
    Write-Log ("{0} {1} @ {2}" -f $msg,$APP_API_URI, (Get-APIGatewayIP))
    Write-Log "Application successfully deployed. . ."
}
else {
    Write-Log ("Errors encountered while deploying application. Please review. Application Name: {0}" -f $AppName )
} 