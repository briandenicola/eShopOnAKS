Architecture
=============
The eShop is a reference .NET application that demonstrates how to implement an e-commerce website using a microservices-based architecture. The application is composed of several small, independent services that work together to provide the overall functionality. Each service focuses on a specific business capability (e.g., product catalog, shopping cart, order processing, payment, etc.).

Additional details about the eShop application architecture are provided at [Introducin eShop Reference App](https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/introduce-eshoponcontainers-reference-app)

## Technology Stack:
* The eShop application is built using .NET Core and Docker containers.
* It is cross-platform and runs on Linux, Windows, and macOS but for this example eShop will use Kuberenetes as the application platform.
* The services communicate with each other using REST APIs or other communication protocols.
* GitHub Repository
    * The code for the eShop application is hosted on GitHub: [eShop GitHub Repository](https://github.com/briandenicola/eshop)
    * You can explore the repository to understand how the different services are organized and implemented.
<p align="right">(<a href="#Architecture">back to top</a>)</p>

Identity API
=============
The identity-api handles user authentication and authorization using OIDC. It provides endpoints for user registration, login, and token management. Users are storaged in a local PostgreSQL database. 
The Identity API is accessible externally via the `https://identity.${APP_NAME}.${DOMAIN_ROOT}` URL and internally via `http://identity-api` URL.
<p align="right">(<a href="#Architecture">back to top</a>)</p>

Basket API
=============
The basket-api is a microservice responsible for managing the user’s shopping cart or basket. The basket-api uses Redis as the database to store the shopping cart information.The basket-api collaborates with other microservices through the Event bus for asynchronous communication.
The Basket API is accessible through a cluster only endpoint  via via `http://basket-api`.

<p align="right">(<a href="#Architecture">back to top</a>)</p>

Catalog API
=============
The catalog-api is responsible for managing product information in the e-commerce system.  The catalog-api uses PostgreSQL as the database to store product information. The catalog-api integrates with the basket, order, and payment services through the Event bus for asynchronous communication.
The Catalog API is accessible through a cluster only endpoint  via via `http://catalog-api`.

<p align="right">(<a href="#Architecture">back to top</a>)</p>

Ordering API
=============
The ordering-api manages the order processing workflow. It handles creating, updating, and retrieving orders. There are two components - ordering-api and the order-processor. The ordering-api is responsible for managing the order information, while the order-processor processes the order and sends it to the payment service for payment processing.  The ordering-api uses PostgreSQL as the database to store order information. The ordering-api integrates with the basket, catalog, and payment services through the Event bus for asynchronous communication.
The Ordering API is accessible through a cluster only endpoint  via via `http://ordering-api`.
<p align="right">(<a href="#Architecture">back to top</a>)</p>

Payment API
=============
The payment service handles payment processing for completed orders It integrates with external payment gateways or services. It does not have any database dependencies. The payment service integrates with the ordering service through the Event bus for asynchronous communication.
The Payment API is accessible through a cluster only endpoint  via via `http://payment-api`.
<p align="right">(<a href="#Architecture">back to top</a>)</p>

Webapp
=============
The web front end is a Blazor WebAssembly application that provides the user interface for the e-commerce system. The web front end communicates with the backend services using REST APIs. The web front end is a single-page application (SPA) that runs in the user’s browser and interacts with the backend services to provide the e-commerce functionality.
The Identity API is accessible externally via the `https://shop.${APP_NAME}.${DOMAIN_ROOT}` URL and internally via `http://webapp` URL.
<p align="right">(<a href="#Architecture">back to top</a>)</p>

Webhooks API
=============
Webhooks are used to subscribe to specific events in a application.
The webhooks-api allows your server to receive HTTP POST payloads when certain events occur in the e-commerce system.

<p align="right">(<a href="#Architecture">back to top</a>)</p>

## Navigation
[Return to Main Index 🏠](../README.md) ‖
[Next Section ⏩](./prerequisites.md)
<p align="right">(<a href="#Architecture">back to top</a>)</p>