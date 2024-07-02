Overview
=================
This repository is a workshop that demonstrates a method to deploy the eShop application to Azure Kubernetes Service (AKS). The [eShop application](https://github.com/dotnet/eshop) is a sample .NET 8 microservices application based on the [Aspire framework](https://learn.microsoft.com/en-us/dotnet/aspire/get-started/aspire-overview). An accompanying ebook on the eShop application can be found [here](https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/introduce-eshoponcontainers-reference-app).

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://codespaces.new/briandenicola/eShopOnAKS?quickstart=1)
[![Open in Dev Containers](https://img.shields.io/static/v1?style=for-the-badge&label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/briandenicola/eShopOnAKS)  

Detaild Documentation
============
[Table of Contents](./toc.md)

High Level Architecture
============
The following is high level architecture of the eShop application and its Azure components. 
<p style="text-align:center;">
    <img src=".assets/eshop_architecture.png" width="1024px" />
    <img src=".assets/eshop.png" width="1024px" />
</p>

<p align="right">(<a href="#overview">back to top</a>)</p>



Copilot
============
If you need clarification on any documentation, you can leverage Github Copilot for assitance. Just highlight the code snippet and type `/explian` in the Copilot prompt.

<p style="text-align:center;">
    <img src=".assets/copilot-2.pg" width="1024px" />
    <img src=".assets/copilot-1.png" width="1024px" />
</p>


Roadmap
============
- [x] Build container images
- [x] Deploy to Kubernetes
- [x] Add Keda Scalers Examples
- [x] Review Azure Monitor and Application Insights
- [x] Update documentation
- [ ] A Java-based Version
<p align="right">(<a href="#overview">back to top</a>)</p>

Acknowledgments
============
* [The eShop Team](https://github.com/dotnet/eshop)
* [The dotnet Team](https://github.com/dotnet)
* [Azure Mission Critical](https://github.com/Azure/Mission-Critical-Connected)
* [Reliable Web Workshop](https://github.com/Azure/reliable-web-app-pattern-dotnet-workshop)
* [Ben Coleman](https://github.com/benc-uk/kube-workshop)


<p align="right">(<a href="#overview">back to top</a>)</p>
