Overview
=================
A sample .NET Core distributed application based on eShopOnContainers, powered by Dapr. The current version targets .NET 7.

The accompanying e-book Dapr for .NET developers uses the sample code in this repository to demonstrate Dapr features and benefits. You can read the online version and download the PDF for free.

Table of contents
=================
<!--ts-->
* [Architecture](./docs/architecture.md#basket-api)
    * [Technology Stack](./docs/architecture.md#technology-stack)
    * [Webapp](./docs/architecture.md#webapp)
    * [Services - Basket API](./docs/architecture.md#basket-api)
    * [Services - Catalog API](./docs/architecture.md#catalog-api)
    * [Services - Identity API](./docs/architecture.md#identity-api)
    * [Services - Ordering API](./docs/architecture.md#ordering-api)
    * [Services - Payment API](./docs/architecture.md#payment-api)
    * [Webhooks](./docs/architecture.md#webhooks)
    * [Code Updates to eShop](./docs/code.md)
* [Prerequisites](./docs/prerequisites.md)
    * [Tools](./docs/prerequisites.md#tools)
    * [Task](./docs/prerequisites.md#task)
    * [Gihub Codespaces](./docs/prerequisites.md#github-codespaces)
    * [Firewall Update](./docs/prerequisites.md#firewall)
* [Infrastructure](./docs/infrastructure.md)
    * [Infrastructure Task Steps](./docs/build.md#steps)
    * [Components - Resource Groups](./docs/infrastructure.md#resource-groups)
    * [Components - Networking](./docs/infrastructure.md#networking)
    * [Components - AKS Cluster](./docs/infrastructure.md#aks-cluster-components)
    * [Components - Monitoring](./docs/infrastructure.md#monitoring)
    * [Components - Redis](./docs/infrastructure.md#redis)
    * [Components - PostgreSQL](./docs/infrastructure.md#postgresql)
    * [Components - EventBus](./docs/infrastructure.md#eventbus)
    * [Post AKS Cluster Configuration](./docs/post-cluster-configuration.md)
    * [Example Setup](./docs/build.md#example-setup)
* [Application Build](./docs/build.md)
    * [Build Task Steps](./docs/build.md#steps)
    * [Example Build](./docs/build.md#example-build)
* [Application Deployment](./docs/deployment.md)
    * [Deployment Task Steps](./docs/deployment.md#steps)
    * [Components - Helm Chart](./docs/deployment.md#helm-chart)
    * [Components - Virtual Services](./docs/deployment.md#virtual-services)    
    * [Secrets & ConfigMaps](./docs/deployment.md#secrets--configmaps)
    * [Example Deployment](./docs/build.md#example-deployment)
* [Monitoring Application](./docs/monitoring.md)
    * [Open Telemetry Pipeline](./docs/monitoring.md#open-telemetry-pipeline)
* [Scaling](./docs/scaling.md)
    * [Keda HTTP Scaler](./docs/scaling.md#keda-http-scaler)
    * [Pod Disruption Budget](./docs/scaling.md#pod-disruption-budget)
* [Cost Management](./docs/cost-management.md)
* [Testing](./docs/testing.md)
    * [Playwright](./docs/testing.md#playwright)
    * [Chaos Engineering](./docs/testing.md#chaos-engineering)
    * [Troubleshooting](./docs/testing.md#troubleshooting)
* [Roadmap](#Roadmap)
* [Code of Conduct](./CODE_OF_CONDUCT.md)
* [Contributing](./CONTRIBUTING.md)
* [Acknowledgments](#Acknowledgments)
<!--te-->
<p align="right">(<a href="#overview">back to top</a>)</p>

Diagrams
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
