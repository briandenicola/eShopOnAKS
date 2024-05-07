#!/usr/bin/pwsh

[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $AppName,
  
    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $SubscriptionName,

    [Parameter(ParameterSetName = 'Default', Mandatory=$true)]
    [string] $SourceRootDirectory
)

. ./modules/eshop_functions.ps1
. ./modules/eshop_naming.ps1 -AppName $AppName

#Connect to Azure and Log into ACR
Add-AzureCliExtensions
Start-Docker

Connect-ToAzure -SubscriptionName $SubscriptionName
Connect-ToAzureContainerRepo -ACRName $APP_ACR_NAME

#Build and Push All Containers from Source 
$commit_version = Get-GitCommitVersion -Source "."

foreach( $Service in $Services ) {
    $SourcePath = Join-Path -Path $SourceRootDirectory -ChildPath $Service.Path
    Build-DockerContainers -ContainerRegistry "${APP_ACR_NAME}.azurecr.io" -ContainerImageTag ${commit_version} -SourcePath $SourcePath
}

if($?){
    Write-Log "Application successfully built and pushed to ${APP_ACR_NAME}. . ."
}
else {
    Write-Log ("Errors encountered while deploying application. Please review. Application Name: {0}" -f $AppName )
} 