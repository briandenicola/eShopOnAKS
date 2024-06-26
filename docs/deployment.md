Deployment
=============
* Deploys the eShop application via Helm to the AKS cluster.
* The deploy process is kicked off using the command: `task deploy` command which runs the script `scripts/deploy-services.ps1`. 
* The script gathers the required infromation needed to pass to the Helm Chart and then deploys the application components.
* Some information is gathered by convention.  Others are gathered from the Azure resources created in the previous section.
* The deployment script first deploys the infrastructure components - EventBus and if required Redis and PostgreSQL.
* The deployment script then deploys the eShop application components.

# Steps
## :heavy_check_mark: Deploy Task Steps
- :one: Open charts/app/templates/basket.yaml.  
    * Review and uncomment the various sections that are commented out.  What do these sections do?  How do they affect the deployment?
    * Save and exit the file.
- :two: `task deploy`     - Deploys application via Helm
<p align="right">(<a href="#deployment">back to top</a>)</p>

## :heavy_check_mark: Manual Build Steps
```pwsh
    . ./scripts/modules/eshop_naming.ps1 -AppName $AppName
    . ./scripts/modules/eshop_functions.ps1

    $commit_version = Get-GitCommitVersion -Source "."
    $app_insights_key = Get-AppInsightsKey -AppInsightsAccountName $APP_AI_NAME -AppInsightsResourceGroup $MONITORING_RG_NAME
    $app_msi  = Get-MSIAccountInfo -MSIName $APP_SERVICE_ACCT -MSIResourceGroup $APP_RG_NAME

    $deploy_redis = -not ( Find-AzureResource -ResourceGroupName $APP_RG_NAME -ResourceName $APP_CACHE_NAME )
    $deploy_sql   = -not ( Find-AzureResource -ResourceGroupName $APP_RG_NAME -ResourceName $APP_SQL_NAME )

    $eventbus_password = New-Password -Length 30
    $sql_password = New-Password -Length 30
    $redis_password = New-Password -Length 30

    helm upgrade -i ${INFRA_CHART_NAME} `
        --set APP_NAME=$AppName `
        --set APP_INSIGHTS.CONNECTION_STRING=$($app_insights_key.connection_string) `
        --set EVENTBUS.PASSWORD=$eventbus_password `
        --set POSTGRESQL.PASSWORD=$sql_password `
        --set REDIS.PASSWORD=$redis_password `
        --set DEPLOY.REDIS="$deploy_redis" `
        --set DEPLOY.SQL="$deploy_sql" `
        ../charts/infrastructure

    helm upgrade -i ${CHART_NAME} `
        --set APP_NAME=$AppName `
        --set NAMESPACE=$APP_NAMESPACE `
        --set GIT_COMMIT_VERSION=$commit_version `
        --set WORKLOAD_ID.CLIENT_ID=$($app_msi.client_id) `
        --set WORKLOAD_ID.TENANT_ID=$($app_msi.tenant_id) `
        --set WORKLOAD_ID.NAME=$APP_SERVICE_ACCT `
        --set KEYVAULT.NAME=$APP_KV_NAME `
        --set EVENTBUS.PASSWORD=$eventbus_password `
        --set POSTGRESQL.PASSWORD=$sql_password `
        --set ACR.NAME=$APP_ACR_NAME `
        --set REGION=$($cogs.region) `
        --set APP_INSIGHTS.CONNECTION_STRING=$($app_insights_key.connection_string) `
        --set ISTIO.GATEWAY=$APP_ISTIO_GATEWAY `
        --set ISTIO.IDENTITY.EXTERNAL_URL="$APP_IDENTITY_URL" `
        --set ISTIO.WEBAPP.EXTERNAL_URL="$APP_URL" `
        --set DEPLOY.REDIS="$deploy_redis" `
        --set DEPLOY.SQL="$deploy_sql" `    
        ../charts/app
```

## Optional Next Steps
* :bulb: eShop has all configurations stored in as AKS Configmaps. What needs to be completed to utilize Azure App Configuration instead? 
* :bulb: eShop is deployed with a [ISTIO Virtual Service](https://istio.io/latest/docs/reference/config/networking/virtual-service/).  What [advance features](https://istio.io/latest/docs/tasks/traffic-management/) could be leverage to bring reliability to the microservices application?  What other ISTIO CRDs could be leveraged?
* :bulb: Create a Github Actions Workload to deploy the application code to the AKS cluster

# Components
## Helm Chart
* The Helm Chart is located in the [charts/app](../charts/app) folder.
* Default values have been set for some of the configurations.  These can be overridden by passing in the values via the `--set` flag.
* The Helm chart metadata is stored in the default namespace
* The Powershell script `scripts/deploy-services.ps1` is a helper script that wraps the helm upgrade command.
* Other values are determined by convention as defined in the ./scripts/modules/eshop_naming.ps1 script.
* Once deployed, you can view the Helm releases by running the following command:
```helm
    > helm list
    NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
    eshop                   default         2               2024-05-20 09:25:22.748077861 -0500 CDT deployed        eshop-1.0.0                     1.0.0
```
<p align="right">(<a href="#deployment">back to top</a>)</p>

## Virtual Services
* The deployment will configure two Istio Virtual Servicves. One for the Web Application and One for the Identity API.
* The Istio Gateway will terminate the SSL connection and route the traffic to the appropriate service over port 80.
* Example Virtual Service configuration:
```yaml
    apiVersion: networking.istio.io/v1beta1
    kind: VirtualService
    metadata:
    name:  webapp-vs
    namespace: {{ .Values.NAMESPACES.APP }}
    spec:
    hosts:
    -  {{ .Values.ISTIO.WEBAPP.EXTERNAL_URL }}
    gateways:
    -  {{ .Values.ISTIO.GATEWAY }}
    http:
    - route:
    - destination:
        host: webapp
        port:
        number: 80
    ---
    apiVersion: networking.istio.io/v1beta1
    kind: VirtualService
    metadata:
    name:  identity-api-vs
    namespace: {{ .Values.NAMESPACES.APP }}
    spec:
    hosts:
    -  {{ .Values.ISTIO.IDENTITY.EXTERNAL_URL }}
    gateways:
    -  {{ .Values.ISTIO.GATEWAY }}
    http:
    - route:
    - destination:
        host: identity-api
        port:
        number: 80
```

## Secrets & ConfigMaps
* Each service has a dedicated Config Map which is used to store the configuration settings for the particular service.
* The deployment will create a set of Kubernetes Secrets that are used by the application.
    * catalogdb-connection-string
    * identitydb-connection-string
    * orderingdb-connection-string
    * webhooksdb-connection-string
    * redis-connection-string
* If Redis and PostgreSQL are deployed in Azure then the connection strings are stored in KeyVault and accessible via the Keyvault CSI driver.
    * The KeyVault Secrets were created during the infrastructure standup process.
    * The SecretProviderClass maps the Keyvault secrets to Kubernetes secrets named `eshop-sql-secrets` and `eshop-redis-secrets` in the eshop namespace,
* Another secret containing the connection string for the EventBus service will also be created and stored in a secret named `eshop-eventbus-secrets` in the eshop namespace.
* These secrets are then referenced by individual services deployments
<p align="right">(<a href="#deployment">back to top</a>)</p>

# Example Deployment
```pwsh
    > task deploy
    task: [deploy] pwsh ./deploy-services.ps1 -AppName airedale-60249 -SubscriptionName Apps_Subscription -Domain bjdazure.tech -verbose
    VERBOSE: [6/4/2024 2:02:36 PM] - Setting subscription context to BJD_Core_Subscription ...
    VERBOSE: [6/4/2024 2:02:38 PM] - Test if Helm chart eshop-infra-components exists ...
    VERBOSE: [6/4/2024 2:02:39 PM] - Deploying eshop-infra-components to airedale-60249-aks into eshop-infra namespace ...
    Release "eshop-infra-components" does not exist. Installing it now.
    NAME: eshop-infra-components
    LAST DEPLOYED: Tue Jun  4 14:02:40 2024
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    VERBOSE: [6/4/2024 2:02:45 PM] - Get Latest Git commit version id ...
    VERBOSE: [6/4/2024 2:02:45 PM] - Get airedale-60249-appinsights Application Insights Account properties ...
    VERBOSE: [6/4/2024 2:05:23 PM] - Get Latest Git commit version id ...
    VERBOSE: [6/4/2024 2:05:23 PM] - Get airedale-60249-appinsights Application Insights Account properties ...
    VERBOSE: [6/4/2024 2:05:25 PM] - Get airedale-60249-app-identity Manage Identity properties ...
    VERBOSE: [6/4/2024 2:05:28 PM] - Get Password for RABBITMQ_DEFAULT_PASS in eshop-sql-secrets ...
    VERBOSE: [6/4/2024 2:05:28 PM] - Secret eshop-sql-secrets not found in eshop-infra namespace ...
    VERBOSE: [6/4/2024 2:05:28 PM] - Get Password for POSTGRES_PASSWORD in eshop-eventbus-secrets ...
    VERBOSE: [6/4/2024 2:05:29 PM] - Secret eshop-eventbus-secrets not found in eshop-infra namespace ...
    VERBOSE: [6/4/2024 2:05:29 PM] - Get Password for REDIS_PASSWORD in eshop-redis-secrets ...
    VERBOSE: [6/4/2024 2:05:30 PM] - Deploying eshop version 28273e95 to airedale-60249-aks into eshop namespace ...
    Release "eshop" has been upgraded. Happy Helming!
    NAME: eshop
    LAST DEPLOYED: Tue Jun  4 14:05:30 2024
    NAMESPACE: default
    STATUS: deployed
    REVISION: 2
    TEST SUITE: None
    VERBOSE: [6/4/2024 2:05:33 PM] - Application successfully deployed ...
    VERBOSE: [6/4/2024 2:05:33 PM] - Open a browser and navigate to Application URL: https://shop.airedale-60249.bjdazure.tech ...

    kubectl --namespace eshop-infra get pods,svc
    NAME                            READY   STATUS    RESTARTS   AGE
    pod/eventbus-dc76f694c-pc2bb    2/2     Running   0          11m
    pod/postgres-85c7c7f66c-nsztw   2/2     Running   0          11m
    pod/redis-5f47b5b8f5-vjzj4      2/2     Running   0          11m

    NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
    service/eventbus   ClusterIP   100.67.208.46    <none>        5672/TCP   11m
    service/postgres   ClusterIP   100.67.53.81     <none>        5432/TCP   11m
    service/redis      ClusterIP   100.67.201.209   <none>        6379/TCP   11m

    > kubectl --namespace eshop get serviceaccount
    NAME                          SECRETS   AGE
    airedale-60249-app-identity   0         7m22s

    > kubectl --namespace eshop get pods
    NAME                              READY   STATUS    RESTARTS      AGE
    basket-api-7d99bc75cc-pxgc4       2/2     Running   0             6m6s
    catalog-5f499874f5-7xkd6          2/2     Running   0             6m6s
    identity-api-58c7685658-7lnp6     2/2     Running   0             6m6s
    mobile-bff-674c78d75f-p89w2       2/2     Running   0             6m6s
    order-processor-f8c57db6b-r45wj   2/2     Running   0             6m6s
    ordering-api-5fdfd5597-r45qw      2/2     Running   0             6m6s
    webapp-6969f4fd84-bnkvw           2/2     Running   0             6m6s
    webhookclient-55f476cff5-n5cxd    2/2     Running   0             6m6s
    webhooks-api-78bd88f645-fvtdp     2/2     Running   0             6m6s

    > kubectl --namespace eshop get secrets
    NAME                     TYPE     DATA   AGE
    eshop-eventbus-secrets   Opaque   1      9m52s
    eshop-redis-secrets      Opaque   1      9m52s
    eshop-sql-secrets        Opaque   4      9m52s

    > kubectl --namespace eshop get configmap
    NAME                 DATA   AGE
    basket-cm            9      7m3s
    catalog-cm           9      7m3s
    identity-cm          11     7m3s
    istio-ca-root-cert   1      7m5s
    kube-root-ca.crt     1      7m5s
    mobile-bff-cm        10     7m3s
    ordering-cm          9      7m3s
    webapp-cm            16     7m3s
    webhookclient-cm     11     7m3s
    webhooks-api-cm      9      7m3s

    > kubectl --namespace eshop get virtualservice
    NAME              GATEWAYS                                     HOSTS                                       AGE
    identity-api-vs   ["aks-istio-ingress/istio-ingressgateway"]   ["identity.airedale-60249.bjdazure.tech"]   26m
    webapp-vs         ["aks-istio-ingress/istio-ingressgateway"]   ["shop.airedale-60249.bjdazure.tech"]       26m
```
<p align="right">(<a href="#deployment">back to top</a>)</p>

# Navigation
[Previous Section ⏪](./build.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./monitoring.md)
<p align="right">(<a href="#deployment">back to top</a>)</p>
