Overview
=================
A sample .NET Core distributed application based on eShopOnContainers, powered by Dapr. The current version targets .NET 7.

The accompanying e-book Dapr for .NET developers uses the sample code in this repository to demonstrate Dapr features and benefits. You can read the online version and download the PDF for free.

Table of contents
=================
<!--ts-->
* [Architecture](./docs/architecture.md#basket-api)
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
    * [Firewall Update](./docs/prerequisites.md#firewall)
* [Infrastructure](./docs/infrastructure.md) 
    * [Networking](./docs/infrastructure.md#networking)
    * [AKS Cluster Components](./docs/infrastructure.md#aks-cluster-components)
    * [GitOps](./docs/infrastructure.md#gitops)
    * [Redis](./docs/infrastructure.md#redis)
    * [PostgreSQL](./docs/infrastructure.md#postgresql)
    * [EventBus](./docs/infrastructure.md#eventbus)
* [Application Build](./docs/build.md)
    * [Example Build](./docs/build.md#dotnet-publish)
* [Application Deployment](./docs/deployment.md)
    * [Helm](./docs/deployment.md#helm-chart)
    * [Ingress](./docs/deployment.md#ingress)
    * [Certificates](./docs/deployment.md#certificates)
    * [Secrets & Configuration](./docs/deployment.md#secrets-management)
* [Monitoring Application](./docs/monitoring.md)
    * [Open Telemetry Pipeline](./docs/monitoring.md#open-telemetry-pipeline)
* [Scaling](./docs/scaling.md)
    * [Keda HTTP Scaler](./docs/scaling.md#keda-http-scaler)
    * [Pod Disruption Budget](./docs/scaling.md#pod-disruption-budget)
* [Security](./docs/security.md)
* [Cost Management](./docs/cost-management.md)
* [Troubleshooting](./docs/troubleshooting.md)
    * [Chaos Engineering](./docs/troubleshooting.md#chaos-engineering)
* [Roadmap](#Roadmap)
* [Code of Conduct](./CODE_OF_CONDUCT.md)
* [Contributing](./CONTRIBUTING.md)
* [Acknowledgments](#Acknowledgments)
<!--te-->
<p align="right">(<a href="#overview">back to top</a>)</p>

Diagram
============
![eShop Reference Application architecture diagram](.assets/eshop_architecture.png)
![eShop Reference Application Home page](.assets/eshop_homepage.png)
<p align="right">(<a href="#overview">back to top</a>)</p>

Roadmap
============
- [x] Build container images
- [x] Deploy to Kubernetes
- [x] Add Keda Scalers Examples
- [x] Review Azure Monitor and Application Insights
- [x] Update documentation
<p align="right">(<a href="#overview">back to top</a>)</p>

Acknowledgments
============
* [The eShop Team](https://github.com/dotnet/eshop)
* [The dotnet Team](https://github.com/dotnet)
* [Ben Coleman](https://github.com/benc-uk/kube-workshop)

<p align="right">(<a href="#overview">back to top</a>)</p>
