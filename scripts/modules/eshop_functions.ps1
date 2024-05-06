function Write-Log 
{
    param( [string] $Message )
    Write-Verbose -Message ("[{0}] - {1} ..." -f $(Get-Date), $Message)
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