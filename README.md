Overview
=================
A sample .NET Core distributed application based on eShopOnContainers, powered by Dapr. The current version targets .NET 7.

The accompanying e-book Dapr for .NET developers uses the sample code in this repository to demonstrate Dapr features and benefits. You can read the online version and download the PDF for free.

Table of contents
=================
<!--ts-->
* [Architecture](#architecture)
* [Prerequisites](./docs/prerequisites.md)
    * [Gihub Codespaces](./docs/prerequisites.md#github-codespaces)
* [Infrastructure](./docs/installation.md) 
    * [GitOps](./docs/installation.md#gitops)
    * [Networking](./docs/installation.md#networking)
    * [Cluster Setup](./docs/installation.md#cluster-setup)
* [Application Build](./docs/build.md)
* [Application Deployment](./docs/deployment.md)
    * [Secrets Management](./docs/deployment.md#secrets-management)
    * [Service Mesh](./docs/deployment.md#service-mesh)
    * [Github Actions](./docs/deployment.md#github-actions)
* [Monitoring Application](./docs/monitoring.md)
* [Scaling](./docs/scaling.md)
* [Security](./docs/security.md)
* [Cost Management](./docs/cost-management.md)
* [Backlog](#backlog)
<!--te-->

Architecture 
============
![eShop Reference Application architecture diagram](.assets/eshop_architecture.png)
![eShop Reference Application Home page](.assets/eshop_homepage.png)

Backlog
============
- [X] Build container images
- [X] Deploy to Kubernetes
- [x] Add Keda Scalers Examples
- [X] Review Azure Monitor and Application Insights
- [ ] Update documentation