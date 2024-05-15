Overview
=================
A sample .NET Core distributed application based on eShopOnContainers, powered by Dapr. The current version targets .NET 7.

The accompanying e-book Dapr for .NET developers uses the sample code in this repository to demonstrate Dapr features and benefits. You can read the online version and download the PDF for free.

Table of contents
=================
<!--ts-->
* [Architecture](#architecture)
    * [Basket API](./docs/architecture.md#basket-api)
    * [Catalog API](./docs/architecture.md#catalog-api)
    * [Identity API](./docs/architecture.md#identity-api)
    * [Ordering API](./docs/architecture.md#ordering-api)
    * [Payment API](./docs/architecture.md#payment-api)
    * [Webapp](./docs/architecture.md#webapp)
    * [Webhooks](./docs/architecture.md#webhooks)
    * [Code Updates to eShop](./docs/code.md)
* [Prerequisites](./docs/prerequisites.md)
    * [Gihub Codespaces](./docs/prerequisites.md#github-codespaces)
* [Infrastructure](./docs/infrastructure.md) 
    * [Networking](./docs/infrastructure.md#networking)
    * [AKS Cluster Components](./docs/infrastructure.md#aks-cluster-components)
    * [GitOps](./docs/infrastructure.md#gitops)
    * [Redis](./docs/infrastructure.md#redis)
    * [PostgreSQL](./docs/infrastructure.md#postgresql)
    * [EventBus](./docs/infrastructure.md#eventbus)
* [Application Build](./docs/build.md)
    * [Dotnet Build](./docs/build.md#dotnet-publish)
    * [Firewall Update](./docs/build.md#firewalls)
* [Application Deployment](./docs/deployment.md)
    * [Pod Disruption Budget](./docs/deployment.md#pod-disruption-budget)
    * [Secrets Management](./docs/deployment.md#secrets-management)
    * [Service Mesh](./docs/deployment.md#service-mesh)
    * [Github Actions](./docs/deployment.md#github-actions)
* [Monitoring Application](./docs/monitoring.md)
* [Scaling](./docs/scaling.md)
* [Security](./docs/security.md)
* [Cost Management](./docs/cost-management.md)
* [Troubleshooting](./docs/troubleshooting.md)
    * [Chaos Engineering](./docs/troubleshooting.md#chaos-engineering)
* [Roadmap](#Roadmap)
* [Code of Conduct](./CODE_OF_CONDUCT.md)
* [Contributing](./CONTRIBUTING.md)
* [Acknowledgments](#Acknowledgments)
<!--te-->
<p align="right">(<a href="#readme-top">back to top</a>)</p>

Architecture 
============
![eShop Reference Application architecture diagram](.assets/eshop_architecture.png)
![eShop Reference Application Home page](.assets/eshop_homepage.png)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

Roadmap
============
- [X] Build container images
- [X] Deploy to Kubernetes
- [x] Add Keda Scalers Examples
- [X] Review Azure Monitor and Application Insights
- [ ] Update documentation
<p align="right">(<a href="#readme-top">back to top</a>)</p>

Acknowledgments
============
* [The eShop Team](https://github.com/dotnet/eshop)
* [The dotnet Team](https://github.com/dotnet)
* [Ben Coleman](https://github.com/benc-uk/kube-workshop)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
