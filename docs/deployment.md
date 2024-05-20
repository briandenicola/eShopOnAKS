Deployment
=============
* Deploys the eShop application via Helm to the AKS cluster.
* The build process is kicked off using the command: `task deploy` command which runs the script `scripts/deploy-services.ps1`. 
* The script gathers the required infromation needed to pass to the Helm Chart and then deploys the application.
* Some information is gathered by convention.  Others are gathered from the Azure resources created in the previous section.

## Task Steps:
- :one: `task deploy`     - Deploys application via Helm
<p align="right">(<a href="#deployment">back to top</a>)</p>

Helm Chart
=============
* The Helm Chart is located in the [charts/app](../charts/app) folder.
* Default values have been set for some of the configurations.  These can be overridden by passing in the values via the `--set` flag.
* The Helm chart metadata is stored in the default namespace
* The Powershell script `scripts/deploy-services.ps1` is a helper script that wraps the helm upgrade command.
* Some values are gathered from the Azure resources created in the previous section.
```pwsh
$commit_version = Get-GitCommitVersion -Source "."
$app_insights_key = Get-AppInsightsKey -AppInsightsAccountName $APP_AI_NAME -AppInsightsResourceGroup $MONITORING_RG_NAME
$app_msi  = Get-MSIAccountInfo -MSIName $APP_SERVICE_ACCT -MSIResourceGroup $APP_RG_NAME
$eventubs_password = New-Password -Length 30
```
* Other values are determined by convention as defined in the ./scripts/modules/eshop_naming.ps1 script.
* The ultimate Helm command that is run is:
```helm
> helm upgrade -i ${CHART_NAME} `
--set APP_NAME=$AppName `
--set NAMESPACE=$APP_NAMESPACE `
--set GIT_COMMIT_VERSION=$commit_version `
--set WORKLOAD_ID.CLIENT_ID=$($app_msi.client_id) `
--set WORKLOAD_ID.TENANT_ID=$($app_msi.tenant_id) `
--set WORKLOAD_ID.NAME=$APP_SERVICE_ACCT `
--set KEYVAULT.NAME=$APP_KV_NAME `
--set EVENTBUS.PASSWORD=$eventbus_password `
--set ACR.NAME=$APP_ACR_NAME `
--set REGION=$($cogs.region) `
--set APP_INSIGHTS.CONNECTION_STRING=$($app_insights_key.connection_string) `
--set ISTIO.GATEWAY=$APP_ISTIO_GATEWAY `
--set ISTIO.IDENTITY.EXTERNAL_URL="$APP_IDENTITY_URL" `
--set ISTIO.WEBAPP.EXTERNAL_URL="$APP_URL" `
../charts/app
> helm list
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
eshop                   default         2               2024-05-20 09:25:22.748077861 -0500 CDT deployed        eshop-1.0.0                     1.0.0
eshop-k8s-extensions    default         2               2024-05-20 09:15:06.180620377 -0500 CDT deployed        eshop-k8s-extensions-1.0.0      1.0.0
```
<p align="right">(<a href="#deployment">back to top</a>)</p>

Virtual Services
=============
* The deployment will configure two Istio Virtual Servicves. One for the Web Application and One for the Identity API.
* The Istio Gateway will terminate the SSL connection and route the traffic to the appropriate service over port 80.
* The Virtual Service configuration can be extended with additional features such as rate limiting, retries, and timeouts.
* Example Virtual Service configuration:
```yaml
        apiVersion: networking.istio.io/v1beta1
        kind: VirtualService
        metadata:
        name:  webapp-vs
        namespace: {{ .Values.NAMESPACE }}
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
        namespace: {{ .Values.NAMESPACE }}
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

Secrets & Config Map
=============
* Each service has a dedicated Config Map which is used to store the configuration settings for the particular service.
    * An exercise for the reader is to replace the Config Maps with Azure App Configuration.
* The deployment will create a set of Kubernetes Secrets that are used by the application via the Azure Keyvault CSI driver.
* The following connection strings were stored in the Keyvault as secrets:
    * catalogdb-connection-string
    * identitydb-connection-string
    * orderingdb-connection-string
    * webhooksdb-connection-string
    * redis-connection-string
* The secrets were created during the infrastructure standup process.
* The SecretProviderClass maps the Keyvault secrets to Kubernetes secrets named `eshop-kv-secrets` in the eshop namespace,
* Another secret containing the connection string for the EventBus service will also be created and stored in a secret named `eventbus-secret` in the eshop namespace.
* These secrets are then referenced by individual services deployments
<p align="right">(<a href="#deployment">back to top</a>)</p>

Example Deployment
=============
```pwsh
    > task deploy
    task: [deploy] pwsh ./deploy-services.ps1 -AppName airedale-60249 -SubscriptionName Apps_Subscription -Domain bjdazure.tech -verbose
    VERBOSE: [05/20/2024 09:25:15] - Setting subscription context to Apps_Subscription ...
    VERBOSE: [05/20/2024 09:25:15] - Get airedale-60249-aks AKS Credentials ...
    The behavior of this command has been altered by the following extension: aks-preview
    Merged "airedale-60249-aks" as current context in /home/brian/.kube/config
    VERBOSE: [05/20/2024 09:25:17] - Get Latest Git commit version id ...
    VERBOSE: [05/20/2024 09:25:17] - Get airedale-60249-appinsights Application Insights Account properties ...
    VERBOSE: [05/20/2024 09:25:19] - Get airedale-60249-app-identity Manage Identity properties ...
    VERBOSE: [05/20/2024 09:25:22] - Deploying eshop version d6258e11 to airedale-60249-aks into eshop namespace. . . ...
    Release "eshop" has been upgraded. Happy Helming!
    NAME: eshop
    LAST DEPLOYED: Mon May 20 09:25:22 2024
    NAMESPACE: default
    STATUS: deployed
    REVISION: 2
    TEST SUITE: None
    VERBOSE: [05/20/2024 09:25:37] - Application successfully deployed ...
    VERBOSE: [05/20/2024 09:25:37] - Open a browser and navigate to Application URL: shop.airedale-60249.bjdazure.tech ...

    > kubectl --namespace eshop get serviceaccount
    NAME                          SECRETS   AGE
    airedale-60249-app-identity   0         7m22s

    > kubectl --namespace eshop get pods
    NAME                              READY   STATUS    RESTARTS      AGE
    basket-api-7d99bc75cc-pxgc4       2/2     Running   0             6m6s
    catalog-5f499874f5-7xkd6          2/2     Running   0             6m6s
    eventbus-847cf67bd9-8zgrn         2/2     Running   0             6m6s
    identity-api-58c7685658-7lnp6     2/2     Running   0             6m6s
    mobile-bff-674c78d75f-p89w2       2/2     Running   0             6m6s
    order-processor-f8c57db6b-r45wj   2/2     Running   0             6m6s
    ordering-api-5fdfd5597-r45qw      2/2     Running   0             6m6s
    webapp-6969f4fd84-bnkvw           2/2     Running   0             6m6s
    webhookclient-55f476cff5-n5cxd    2/2     Running   0             6m6s
    webhooks-api-78bd88f645-fvtdp     2/2     Running   0             6m6s

    > kubectl --namespace eshop get secrets
    NAME               TYPE     DATA   AGE
    eshop-kv-secrets   Opaque   5      6m35s
    eventbus-secret    Opaque   2      6m39s

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

## Navigation
[Return to Main Index 🏠](../README.md) ‖
[Previous Section ⏪](./build.md) ‖ [Next Section ⏩](./monitoring.md)
<p align="right">(<a href="#deployment">back to top</a>)</p>