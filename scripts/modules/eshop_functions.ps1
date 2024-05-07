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

function Add-AzureCliExtensions
{
    az extension add --name application-insights -y
    az extension add --name aks-preview -y
}

function Start-Docker
{
    Write-Log -Message "Starting Docker"
    if(Get-OSType -eq "Unix") {
        sudo /etc/init.d/docker start
    }
    else {
        Start-Service -Name docker
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
    dotnet publish -t:PublishContainer -p ContainerImageTags=$ContainerImageTag -p ContainerRegistry=${ContainerRegistry} $SourcePath
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