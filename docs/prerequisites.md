Prerequisites
=============

The following tools and build environment has been tested to work on Linux and on Windows using WSL2.  While all the tools have Windows equivalents, the instructions provided are for Linux and have not been fully tested. 

## Required Tools
* A Posix compliant System. It could be one of the following:
    * [Github CodeSpaces](https://github.com/features/codespaces)
    * [Azure Cloud Shell](https://shell.azure.com/)
    * Azure Linux VM - Standard_B1s VM will work ($18/month)
    * Windows 11 with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install)
    * MacOS might work but was not tested
* [dotnet 8](https://dotnet.microsoft.com/download) - The .NET SDK
* [Visual Studio Code](https://code.visualstudio.com/) or equivalent - A lightweight code editor
* [Docker](https://www.docker.com/products/docker-desktop) - The Docker Desktop to build/push containers
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - A tool for managing Azure resources
* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell) - The PowerShell Core for running scripts
* [git](https://git-scm.com/) - The source control tool
* [Taskfile](https://taskfile.dev/#/) - A task runner for the shell
* [Terraform](https://www.terraform.io/) - A tool for building Azure infrastructure and infrastructure as code
* [Flux](https://fluxcd.io/) - A tool for managing Kubernetes clusters
* [kubectl](https://kubernetes.io/docs/tasks/tools/) - Another tool for managing Kubernetes clusters
* [helm](https://helm.sh/) - A tool for deploying applications to Kubernetes
* [Trivy](https://github.com/aquasecurity/trivy) - Open Source Vulnerability Scanner for Containers

### Optional Tools
* [Windows Terminal](https://aka.ms/terminal) - A better terminal for Windows
* [Zsh](https://ohmyz.sh/) - A better shell for Linux and Windows
* [k9s](https://k9scli.io/) - A terminal-based UI for Kubernetes
* [.alias.rc](./.alias.rc) - A set of aliases for Linux that can assist with some of the commands in this guide.
    
> * **Note:** The Github Codespaces environment has all the tools pre-installed and configured.  You can use the following link to open the eShop project in Github Codespaces: [Open in Github Codespaces](https://codespaces.new/briandenicola/eShopOnAKS?quickstart=1)
> * **Note:** Scripts to help with the installation of all these tools can be found here: [Install Scripts](https://github.com/briandenicola/tooling)

### Task
* The deployment of this application has been automated using [Taskfile](https://taskfile.dev/#/).  This was done instead of using a CI/CD pipeline to make it easier to understand the deployment process.  
* Of course, the application can be deployed manually
* The Taskfile is a simple way to run commands and scripts in a consistent manner.  
* The [Taskfile](../Taskfile.yaml) definition is located in the root of the repository
* The Task file declares the default values that can be updated to suit specific requirements: 
    Name | Usage | Default Value
    ------ | ------ | ------
    TITLE | Value used in Azure Tags | eShop On AKS
    SKU | Default SKU type for AKS nodes | Standard_D4s_v5
    COUNT | Number of nodes in the AKS cluster | 2
    DEFAULT_REGION | Default region to deploy to | westus3
    DOMAIN_ROOT | Default root domain used for all URLs & certs | bjdazure.tech
    DEPLOY_SQL | Deploy Azure PostgreSQL | false (will deploy PostgreSQL as containers on AKS)
    DEPLOY_REDIS | Deploy Azure Redis |  false (will deploy Redis as containers on AKS)

* Running the `task` command without any options will run the default command. This will list all the available tasks.
    * `task build`              : Builds containers
    * `task certs`              : Update cluster configurations required for Cert Manager
    * `task creds`              : Gets credential file for newly created AKS cluster
    * `task deploy`             : Deploys application via Helm
    * `task dns`                : Gets the IP Addresss of the Istio Gateway
    * `task down`               : Destroys all Azure resources and cleans up Terraform
    * `task init`               : Initialized Terraform modules
    * `task apply`              : Creates Azure infrastructure and deploys application code
    * `task update-firewalls`   : Update firewall rules for Keyvault, AKS, and ACR
    * `task status`             : Get the status of the AKS cluster resources
    * `task restart`            : Performs a rollout restart on all deployments in eshop namespace

## Code
* Clone the eShop Source repository: `git clone https://github.com/briandenicola/eshop`
* Clone the eshop Infrastructure repository: `git clone https://github.com/briandenicola/eshopOnAzure`

## Enivronment
* An Azure subscription. An MSDN subscription will work.
* An account with owner permission on the Azure subscription and Global Admin on the Azure AD tenant
* A valid, external DNS domain name to create a wildcard URL for the eShop application
* An **Azure Service Principal** with Owner role on the Azure subscription  
* :exclamation: Follow this guide to configure [Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-powershell?tabs=bash) with an Service Principal
* :exclamation: The following [Resource Providers](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal) must be enabled: _Microsoft..Monitor, Microsoft.AlertsManagement, Microsoft.Dashboard, Microsoft.KubernetesConfiguration_
    
* :exclamation: Run the following command to enable the preview features on your Azure Subscription: _AKS-ExtensionManager, AKS-PrometheusAddonPreview, EnableImageCleanerPreview, AKS-KedaPreview, EnableAPIServerVnetIntegrationPreview, TrustedAccessPreview,NetworkObservabilityPreview, AKS-AzurePolicyExternalData_
    ```pwsh
    pwsh ./scripts/aks-preview-features.ps1
    ```
<p align="right">(<a href="#prerequisites">back to top</a>)</p>

Github Codespaces
=============
Github Codespaces is a cloud-based development environment that you can access from anywhere.  It is a simple to get started with the eShop project without having to install any tools on your local machine.  
The CodeSpace environment has been configured with the with [Github Copilot](https://github.com/features/copilot) Visual Studio Code extension. Copilot can help you write code, suggest code completions, and even write entire functions for you.  It is a great tool to help you get started with the eShop project.

You can use the following link to launch a Codespaces configured for this project:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/briandenicola/eShopOnAKS?quickstart=1)

> * **Note:** _Codespaces and Copilot require additional licenses and fees.  Please review the [GitHub Pricing](https://github.com/pricing)_
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