Post Cluster Configuration
=============
* After the cluster has been stood up, there are a few configurations that need to be done to ensure that the cluster is ready for deployment that can not be completed easily with Flux/Gitops. This section will cover the following configurations.
* The following configurations will be covered in this section:
  * [Cert Manager Configuration](#cert-manager-configuration)
  * [Istio Ingress Gateway Configuration](#istio-ingress-gateway-configuration)
  * [Open Telemetry Configuration](#open-telemetry-configuration)
* The configurations are deployed via Helm Charts.  It can be found in the [eshop-k8s-extensions](../charts/eshop-k8s-extensions) folder and triggered with `task gateway` and `task certs`.  
* The `task gateway` puls the required values from Terraform's output vaiables and passes them along to the Helm Chart.

# Steps
## :heavy_check_mark: Deploy Task Steps
- :one: `task gateway`  - Update configurations with proper values Key
- :two: `task certs`    - Gets the Challenge Information required for Cert Manager
- :three: `task gateway`  - Run a second time after updating the Helm Chart values.yaml file with the challenge settings

## :heavy_check_mark: Manual Configuration Steps
```pwsh
  helm upgrade --install eshop-k8s-extensions --set CERT.EMAIL_ADDRESS={{.APP_NAME}}@bjdazure.tech --set APP_NAME={{.APP_NAME}} --set WEBAPP_DOMAIN={{.APP_NAME}}.{{.DOMAIN_ROOT}} --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/eshop-k8s-extensions
  pwsh ./get-cert-manager-challenges.ps1
  vi /charts/eshop-k8s-extensions/values.yaml
  helm upgrade --install eshop-k8s-extensions --set CERT.EMAIL_ADDRESS={{.APP_NAME}}@bjdazure.tech --set APP_NAME={{.APP_NAME}} --set WEBAPP_DOMAIN={{.APP_NAME}}.{{.DOMAIN_ROOT}} --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/eshop-k8s-extensions
```
<p align="right">(<a href="#post-cluster-configuration">back to top</a>)</p>

# Post Cluster Configuration
## Cert Manager Configuration
* Cert Manager is configured to issue a certificate with the WEBAPP_URL  and the SHOP_URL DNS names
* The certificates are stored in the 'istio-ingress-tls' secret in the 'aks-istio-ingress' namespace.
* Cert Manager is configured to use Let's Encrypt as the certificate issuer with HTTP01 domain validation
* Due to a quirk in how Cert Manager works, the `task gateway` has to be run twice.
* During the first deployment of the Helm chart, Cert Manager will spin up pods to handle the HTTP01 challenge and will create a Ingress configuration for each challenge.
* The `task certs` command will then get the challenge configuration that Cert Manager created, which will be used to manually updated in the [Helm Chart values.yaml](../charts/eshop-k8s-extensions/values.yaml) file:
    * IDENTITY_URL_SERVICE_NAME   - The service name for the identity.${APP_NAME}.${DOMAIN_ROOT} challenge
    * IDENTITY_URL_CHALLENGE_PATH - The Ingress Path for the identity.${APP_NAME}.${DOMAIN_ROOT} challenge
    * SHOP_URL_SERVICE_NAME       - The service name for the shop.${APP_NAME}.${DOMAIN_ROOT} challenge
    * SHOP_URL_CHALLENGE_PATH     - The Ingress Path for the shop.${APP_NAME}.${DOMAIN_ROOT} challenge
* `task gateway` will then be run again to update the Helm Chart with the challenge settings allowing Let's Encrypt to valiate domain ownership and issue the certificate.
  * After the certificate is issued, then the Ingress and validation pods are removed.
<p align="right">(<a href="#post-cluster-configuration">back to top</a>)</p>

## Istio Ingress Gateway Configuration
* The Istio Ingress Gateway is configured to route traffic to the correct services.  The Gateway will be configured to listen for both HTTP and HTTPS traffic for any requests to the WEBAPP_DOMAIN, which is defined as '*.${APP_NAME}.${DOMAIN_ROOT}'.  
* The TLS secret is created by Cert Manager and and stored in the 'istio-ingress-tls' secret in the 'aks-istio-ingress' namespace.
```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: istio-ingressgateway
  namespace: aks-istio-ingress
spec:
  selector:
    istio: aks-istio-ingressgateway-external  
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - {{ print "*." .Values.WEBAPP_DOMAIN | quote }}
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-ingress-tls
    hosts:
    - {{ print "*." .Values.WEBAPP_DOMAIN | quote }}
``` 

## Open Telemetry Configuration
* An Open Telemetry collector is deployed to collect telemetry data from the services running in the cluster.  The collector is configured to send the telemetry data to Azure Monitor.  The configuration is stored in the 'otel-collector-config' ConfigMap in the 'otel-system' namespace.
* Open Telemetry is configured with two receiver protocols - OTLP and Zipkin.  The OTLP receiver is configured to listen on port 4317 and the Zipkin receiver is configured to listen on port 9411.  

```yaml
  receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317            
      zipkin:
        endpoint: 0.0.0.0:9411
  
  exporters:
      azuremonitor:
        connection_string: {{ .Values.APP_INSIGHTS.CONNECTION_STRING  }}
        maxbatchsize: 100
        maxbatchinterval: 10s
```
<p align="right">(<a href="#post-cluster-configuration">back to top</a>)</p>

# Example Configuration
```pwsh
  > task gateway
  task: [gateway] helm upgrade --install eshop-k8s-extensions --set CERT.EMAIL_ADDRESS=airedale-60249@bjdazure.tech --set APP_NAME=airedale-60249 --set WEBAPP_DOMAIN=airedale-60249.bjdazure.tech --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/eshop-k8s-extensions
  Release "eshop-k8s-extensions" does not exist. Installing it now.
  NAME: eshop-k8s-extensions
  LAST DEPLOYED: Mon May 20 09:11:07 2024
  NAMESPACE: default
  STATUS: deployed
  REVISION: 1
  TEST SUITE: None

  > kubectl --namespace aks-istio-ingress get ingress
  NAME                        CLASS   HOSTS                                   ADDRESS   PORTS   AGE
  cm-acme-http-solver-7bgbq   istio   identity.airedale-60249.bjdazure.tech             80      32s
  cm-acme-http-solver-pt5s6   istio   shop.airedale-60249.bjdazure.tech                 80      32s

  > kubectl --namespace aks-istio-ingress get certs
  NAME                           READY   SECRET              AGE
  airedale-60249-bjdazure-tech   False   istio-ingress-tls   39s

  > kubectl --namespace aks-istio-ingress get ingress -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
  cm-acme-http-solver-7bgbq
  cm-acme-http-solver-pt5s6

  > task certs
  task: [certs] pwsh ./get-cert-manager-challenges.ps1
  Getting Challenge settings for cm-acme-http-solver-7bgbq
  Update eshop-k8s-extensions Helm Chart Values.yaml file with the following values for identity.airedale-60249.bjdazure.tech:
          SERVICE_NAME: cm-acme-http-solver-7n2sn
          CHALLENGE_PATH: /.well-known/acme-challenge/ED5THd1E3io1tOV1kbYrwvPSBSxCoPC6iPrUSuBzGla

  Getting Challenge settings for cm-acme-http-solver-pt5s6
  Update eshop-k8s-extensions Helm Chart Values.yaml file with the following values for shop.airedale-60249.bjdazure.tech:
          SERVICE_NAME: cm-acme-http-solver-twsdd
          CHALLENGE_PATH: /.well-known/acme-challenge/FdND99zvAOuooTXxkMkRQSlh7lfbjs_dedorIFWhpDu

  Please re-run `task gateway` after updating the Helm Chart values.yaml file with the challenge settings.

  > task gateway
  task: [gateway] helm upgrade --install eshop-k8s-extensions --set CERT.EMAIL_ADDRESS=airedale-60249@bjdazure.tech --set APP_NAME=airedale-60249 --set WEBAPP_DOMAIN=airedale-60249.bjdazure.tech --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/eshop-k8s-extensions
  Release "eshop-k8s-extensions" has been upgraded. Happy Helming!
  NAME: eshop-k8s-extensions
  LAST DEPLOYED: Mon May 20 09:15:06 2024
  NAMESPACE: default
  STATUS: deployed
  REVISION: 2
  TEST SUITE: None

  > kubectl --namespace aks-istio-ingress get certs
  NAME                           READY   SECRET              AGE
  airedale-60249-bjdazure-tech   True    istio-ingress-tls   5h31m
  
  >kubectl --namespace aks-istio-ingress get secrets
  NAME                                                               TYPE                 DATA   AGE
  istio-ingress-tls                                                  kubernetes.io/tls    2      5h26m
  sh.helm.release.v1.asm-igx-aks-istio-ingressgateway-external.v73   helm.sh/release.v1   1      6m41s
  sh.helm.release.v1.asm-igx-aks-istio-ingressgateway-external.v74   helm.sh/release.v1   1      110s

  > kubectl -n otel-system get pods,svc
  NAME                                  READY   STATUS    RESTARTS   AGE
  pod/otel-collector-855c8457f9-cvqkd   1/1     Running   0          5h32m

  NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
  service/otel-collector   ClusterIP   100.80.56.95   <none>        4317/TCP,9411/TCP   5h32m

  > kubectl --namespace aks-istio-ingress get ingress
  No resources found in aks-istio-ingress namespace.
```

# Navigation
[Previous Section ⏪](./infrastructure.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./build.md)
<p align="right">(<a href="#infrastructure">back to top</a>)</p>
