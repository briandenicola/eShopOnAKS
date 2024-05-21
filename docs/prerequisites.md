Prerequisites
=============

The following tools and build environment has been tested to work on Linux and on Windows using WSL2.  While all the tools have Windows equivalents, the instructions provided are for Linux and have not been fully tested. 

## Tools
* Github CodeSpaces, [Azure Cloud Shell](https://shell.azure.com/) Linux, or Windows with WSL2.
* [dotnet 8](https://dotnet.microsoft.com/download) - The .NET SDK
* [Visual Studio Code or Equivalent](https://code.visualstudio.com/) - A lightweight code editor
* [Docker Desktop](https://www.docker.com/products/docker-desktop) - The Docker Desktop to build/push containers
* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell) - The PowerShell Core for scripting
* [git](https://git-scm.com/) - The source control tool
* [Taskfile](https://taskfile.dev/#/) - A task runner for the shell
* [Terraform](https://www.terraform.io/) - A tool for building Azure infrastructure and infrastructure as code
* [Flux](https://fluxcd.io/) - A tool for managing Kubernetes clusters
* [kubectl](https://kubernetes.io/docs/tasks/tools/) - Another tool for managing Kubernetes clusters
* [helm](https://helm.sh/) - A tool for deploying applications to Kubernetes
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - A tool for managing Azure resources

### Optional Tools
* [Windows Terminal](https://aka.ms/terminal) - A better terminal for Windows
* [Zsh](https://ohmyz.sh/) - A better shell for Linux and Windows
* [.alias.rc](./.alias.rc) - A set of aliases for Linux that can assist with some of the commands in this guide.
    
> * **Note:** The Github Codespaces environment has all the tools pre-installed and configured.  You can use the following link to open the eShop project in Github Codespaces: [Open in Github Codespaces](https://codespaces.new/briandenicola/eShopOnAKS?quickstart=1)
> * **Note:** Scripts to help with the installation of all these tools can be found here: [Install Scripts](https://github.com/briandenicola/tooling)

### Task
* The deployment of this application has been automated using [Taskfile](https://taskfile.dev/#/).  This was done instead of using a CI/CD pipeline to make it easier to understand the deployment process.  
* Of course, the application can be deployed manually
* The Taskfile is a simple way to run commands and scripts in a consistent manner.  
* The [Taskfile](../Taskfile.yaml) definition is located in the root of the repository
* The Task file declares 4 default values that can be updated to suit specific requirements: 
    Name | Usage | Default Value
    ------ | ------ | ------
    TITLE | Value used in Azure Tags | eShop On AKS
    SKU | Default SKU type for AKS nodes | Standard_D4ads_v5
    COUNT | Number of nodes in the AKS cluster | 2
    DEFAULT_REGION | Default region to deploy to | westus3
    DOMAIN_ROOT | Default root domain used for all URLs & certs | bjdazure.tech
* Running the `task` command without any options will run the default command. This will list all the available tasks.
    * `task build`              : Builds containers
    * `task certs`              : Gets the Challenge Information required for Cert Manager
    * `task creds`              : Gets credential file for newly created AKS cluster
    * `task deploy`             : Deploys application via Helm
    * `task dns`                : Gets the IP Addresss of the Istio Gateway
    * `task down`               : Destroys all Azure resources and cleans up Terraform
    * `task gateway`            : Update configurations with proper values Key
    * `task up`                 : Creates Azure infrastructure and deploys application code
    * `task update-firewalls`   : Update firewall rules for Keyvault, AKS, and ACR

## Code
* Clone the eShop Source repository: `git clone https://github.com/briandenicola/eshop`
* Clone the eshop Infrastructure repository: `git clone https://github.com/briandenicola/eshopOnAzure`

## Envrionment
* An Azure subscription. An MSDN subscription will work.
* An account with owner permission on the Azure subscription and Global Admin on the Azure AD tenant
* An Azure Service Principal with Owner role on the Azure subscription
* A valid, external DNS domain name to create a wildcard URL for the eShop application   
* :exclamation: Follow this to [Configured Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-powershell?tabs=bash) properly for Azure
* :exclamation: Run the following command to enable the preview features on your Azure Subscription: _AKS-ExtensionManager, AKS-PrometheusAddonPreview, EnableImageCleanerPreview, AKS-KedaPreview, EnableAPIServerVnetIntegrationPreview, TrustedAccessPreview,NetworkObservabilityPreview, AKS-AzurePolicyExternalData_
    ```pwsh
    pwsh ./scripts/aks-preview-features.ps1
    ```
<p align="right">(<a href="#prerequisites">back to top</a>)</p>

Github Codespaces
=============
Github Codespaces is a cloud-based development environment that you can access from anywhere.  It is a great way to get started with the eShop project without having to install any tools on your local machine.  You can use the following steps to get started with Github Codespaces:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/briandenicola/eShopOnAKS?quickstart=1)
<p align="right">(<a href="#prerequisites">back to top</a>)</p>

Firewall
=============
* If you are using Github Codespaces, the outbound IP address of the compute node is not statics, the firewalls on your Azure resources will be need to be updated from time to time.
* This can be completed by running the following command: `task update-firewalls` which in tern runs the following command:
    ```pwsh
    pwsh ./scripts/update-firewalls.ps1 -AppName $AppName -SubscriptionId $SubscriptionId
    ```

## Navigation
[Return to Main Index 🏠](../README.md) ‖
[Previous Section ⏪](./architecture.md)  ‖ [Next Section ⏩](./infrastructure.md)
<p align="right">(<a href="#prerequisites">back to top</a>)</p>