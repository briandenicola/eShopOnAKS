function Write-Log 
{
    param( [string] $Message )
    Write-Verbose -Message ("[{0}] - {1} ..." -f $(Get-Date), $Message)
}

function New-Password 
{
    param(
        [ValidateRange(8,32)]
        [int] $Length = 25
    )

    function Get-SecureRandomNumber {
        param(
            [int] $min,
            [int] $max
        )

        $rng = New-Object "System.Security.Cryptography.RNGCryptoServiceProvider"
        $rand = [System.Byte[]]::new(1)

        while($true) {
            $rand = [System.Byte[]]::new(1)
            $rng.GetNonZeroBytes($rand)

            $randInt = [convert]::ToInt32($rand[0])
            if( ($randInt -ge $min) -and $randInt -le $max) {
                return $randInt
            }
        }
    }

    $potentialCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    $chars = $potentialCharacters.ToCharArray()
    for($i=0;$i -lt $length; $i++) {
        $index = Get-SecureRandomNumber -Min 0 -Max $chars.Length
        $password += $chars[$index]
    }

    return $password
}

function Find-AzureResource 
{
    param( 
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $ResourceGroupName, 
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $ResourceName
    )

    $exist = az resource list --resource-group $ResourceGroupName --query "[?name=='$ResourceName'] | length(@)"

    if($exist -eq 0) { return $false }
    return $true
}

function ConvertFrom-Base64String
{
    param( 
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $Text 
    )
    return [Text.Encoding]::ASCII.GetString([convert]::FromBase64String($Text))
}

function ConvertTo-Base64EncodedString 
{
    param( 
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $Text 
    )
    begin {
        $encodedString = [string]::Empty
    }
    process {
        $encodedString = [convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Text))
    }
    end {
        return $encodedString
    }
}

function Connect-ToAzure 
{
    param(
        [string] $SubscriptionName
    )

    function Get-AzTokenExpiration {
        $e = (az account get-access-token --query "expiresOn" --output tsv)
        if($null -eq $e){
            return $null
        }        
        return (Get-Date -Date $e)
    }

    function Test-ExpireToken {
        param(
            [DateTime] $Expire
        )
        return (($exp - (Get-Date)).Ticks -lt 0 )
    }

    $exp = Get-AzTokenExpiration
    if( ($null -eq $exp) -or (Test-ExpireToken -Expire $exp)) {
        Write-Log -Message "Logging into Azure"
        az login
    }

    Write-Log -Message "Setting subscription context to ${SubscriptionName}"
    az account set -s $SubscriptionName
    
}

function Connect-ToAzureContainerRepo
{
    param(
        [string] $ACRName

    )

    Write-Log -Message "Logging into ${ACRName} Azure Container Repo"
    az acr login -n $ACRName
}

function Get-GitCommitVersion
{ 

    Write-Log -Message "Get Latest Git commit version id"
    return (git rev-parse HEAD).SubString(0,8)
}

function Build-DockerContainers
{
    param(
        [string] $ContainerRegistry,
        [string] $ContainerImageTag,
        [string] $SourcePath
    )

    Write-Log -Message "Building and publish ${SourcePath}:${ContainerImageTag} to ${ContainerRegistry}"
    dotnet publish -t:PublishContainer -p ContainerImageTag=$ContainerImageTag -p ContainerRegistry=${ContainerRegistry} $SourcePath
    
    #ERROR: The following options generate an access deny error on the Identity.API container on tempkey.jwk file
    #dotnet publish -t:PublishContainer -p ContainerImageTag=$ContainerImageTag -p ContainerRegistry=${ContainerRegistry} -p:PublishSingleFile="true" -p:PublishTrimmed="false" --self-contained "true" --verbosity "quiet" $SourcePath
    
}

function Remove-TerraformState
{
    $items = @(
        '*.plan.*'
        'terraform.tfstate'
        'terraform.tfstate.backup'
        '.terraform'
        '.terraform.lock.hcl'
        'terraform.tfstate.d'
    )
    $items | ForEach-Object {
        Remove-Item -Path (Join-Path -Path $PWD.Path -ChildPath $_) -Recurse -Force -Confirm:$false -Verbose -ErrorAction SilentlyContinue
    }
}

function Get-AKSCredentials 
{
    param(
        [string] $AKSNAME,
        [string] $AKSResourceGroup
    )

    Write-Log -Message "Get ${AKSNAME} AKS Credentials"
    az aks get-credentials -n $AKSNAME -g $AKSResourceGroup --overwrite-existing
    sed -i s/devicecode/azurecli/g ~/.kube/config
}

function Get-MSIAccountInfo
{
    param(
        [string] $MSIName,
        [string] $MSIResourceGroup
    )

    Write-Log -Message "Get ${MSIName} Manage Identity properties"
    return (New-Object psobject -Property @{
        client_id = (az identity show -n $MSIName -g $MSIResourceGroup --query clientId -o tsv)
        resource_id = (az identity show -n $MSIName -g $MSIResourceGroup --query id -o tsv)
        tenant_id = (az identity show -n $MSIName -g $MSIResourceGroup --query tenantId -o tsv)
    })
}

function Get-AppInsightsKey
{
    param(
        [string] $AppInsightsAccountName,
        [string] $AppInsightsResourceGroup
    )

    Write-Log -Message "Get ${AppInsightsAccountName} Application Insights Account properties"
    return (New-Object psobject -Property @{
        key = (az monitor app-insights component show --app $AppInsightsAccountName -g $AppInsightsResourceGroup --query instrumentationKey -o tsv)
        connection_string = (az monitor app-insights component show --app $AppInsightsAccountName -g $AppInsightsResourceGroup --query connectionString -o tsv)
    })
}

function Test-Certificate 
{
    param(
        [string] $CertName,
        [string] $Namespace
    )

    Write-Log -Message "Test if certificate ${CertName} exists in ${Namespace} namespace"
    $status = $(kubectl --namespace aks-istio-ingress get certificate ${CertName} -o jsonpath='{.status.conditions[0].status}')

    if( $status -eq "True" ) { return $true } 
    return $false
}

function Test-HelmChart
{
    param(
        [string] $ChartName
    )

    Write-Log -Message "Test if Helm chart ${ChartName} exists"
    $deployed = helm list -q | Where-Object {$_ -eq $ChartName}

    if($null -eq $deployed) { return $false }
    return $true
}

function Get-Password
{
    param(
        [string] $SecretName,
        [string] $Namespace,
        [string] $Data
    )

    Write-Log -Message "Get Password for ${DATA} in ${SecretName}"
    $value = $(kubectl --namespace $Namespace get secrets $SecretName -o jsonpath="{.data.$Data}" | ConvertFrom-Base64String)

    if([string]::IsNullOrEmpty($value)) {
        Write-Log -Message "Secret ${SecretName} not found in ${Namespace} namespace"
        return "null"
    }
    return $value
}