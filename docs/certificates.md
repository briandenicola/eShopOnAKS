Post Cluster Configuration
=============
* After the cluster has been stood up, there are a few configurations that need to be done to ensure that the cluster is ready for deployment that can not be completed easily with Flux/Gitops. This section will cover the following configurations.
* The following configurations will be covered in this section:
  * [Cert Manager Configuration](#cert-manager-configuration)
  * [Istio Ingress Gateway Configuration](#istio-ingress-gateway-configuration)
* The configurations are deployed via Helm Charts.  It can be found in the [certs](../charts/certs) folder and triggered with `task certs`.  

# Steps
## :heavy_check_mark: Deploy Task Steps
- :one: `task dns`  - Gets the DNS configuration for the cluster
- :two: **MANUAL STEP** - Create DNS records
- :three: `task cert` - Gets the Challenge Information required for Cert Manager

## :heavy_check_mark: Manual Configuration Steps
```pwsh
  helm upgrade --install eshop-certificate --set CERT.EMAIL_ADDRESS={{.APP_NAME}}@bjdazure.tech --set APP_NAME={{.APP_NAME}} --set WEBAPP_DOMAIN={{.APP_NAME}}.{{.DOMAIN_ROOT}} --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/certs
  pwsh ./scripts/get-cert-manager-challenges.ps1
  edit ~/charts/certs/values.yaml
  helm upgrade --install eshop-certificate --set CERT.EMAIL_ADDRESS={{.APP_NAME}}@bjdazure.tech --set APP_NAME={{.APP_NAME}} --set WEBAPP_DOMAIN={{.APP_NAME}}.{{.DOMAIN_ROOT}} --set APP_INSIGHTS.CONNECTION_STRING="InstrumentationKey=REDACTED;IngestionEndpoint=https://westus2-2.in.applicationinsights.azure.com/;LiveEndpoint=https://westus2.livediagnostics.monitor.azure.com/;ApplicationId=REDACTED" ./charts/certs
```
<p align="right">(<a href="#certificates">back to top</a>)</p>

# Post Cluster Configuration
## Cert Manager Configuration
* Cert Manager is configured to issue a certificate with the WEBAPP_URL  and the SHOP_URL DNS names
* The certificates are stored in the 'istio-ingress-tls' secret in the 'aks-istio-ingress' namespace.
* Cert Manager is configured to use Let's Encrypt as the certificate issuer with HTTP01 domain validation
* Due to a quirk in how Cert Manager works, the Helm chart needs to be run twice but the `task cert` task command handles all of this automatically.
* Technically, Cert Manager will spin up pods to handle the HTTP01 challenge and will create a Ingress configuration for each challenge during the first deployment of the Helm chart.
* The get-cert-manager-challenges.ps1` script will then get the challenge configuration that Cert Manager created, which will be used to manually updated in the [Helm Chart values.yaml](../charts/eshop-k8s-extensions/values.yaml) file:
    * IDENTITY_URL_SERVICE_NAME   - The service name for the identity.${APP_NAME}.${DOMAIN_ROOT} challenge
    * IDENTITY_URL_CHALLENGE_PATH - The Ingress Path for the identity.${APP_NAME}.${DOMAIN_ROOT} challenge
    * SHOP_URL_SERVICE_NAME       - The service name for the shop.${APP_NAME}.${DOMAIN_ROOT} challenge
    * SHOP_URL_CHALLENGE_PATH     - The Ingress Path for the shop.${APP_NAME}.${DOMAIN_ROOT} challenge
* A second run of the Helm chart will chart with the challenge settings allowing Let's Encrypt to valiate domain ownership and issue the certificate.
* After the certificate is issued, then the Ingress and validation pods are removed.
<p align="right">(<a href="#certificates">back to top</a>)</p>

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
<p align="right">(<a href="#certificates">back to top</a>)</p>

# Example Configuration
```pwsh
  > task cert
  task: [cert] pwsh ./request-certificate.ps1 -AppName airedale-60249 -DomainName bjdazure.tech -verbose
  VERBOSE: [6/4/2024 1:55:15 PM] - Test if certificate airedale-60249-bjdazure-tech exists in aks-istio-ingress namespace ...
  Error from server (NotFound): certificates.cert-manager.io "airedale-60249-bjdazure-tech" not found
  VERBOSE: [6/4/2024 1:55:16 PM] - Installing chart eshop-certificate to airedale-60249-aks into AKS-ISTIO-INGRESS namespace ...
  Release "eshop-certificates" has been upgraded. Happy Helming!
  NAME: eshop-certificates
  LAST DEPLOYED: Tue Jun  4 13:55:17 2024
  NAMESPACE: default
  STATUS: deployed
  REVISION: 5
  TEST SUITE: None
  VERBOSE: [6/4/2024 1:55:20 PM] - Pause to allow pods to come online ...
  VERBOSE: [6/4/2024 1:55:52 PM] - Getting Challenge settings for identity.airedale-60249.bjdazure.tech ...
  VERBOSE: [6/4/2024 1:55:54 PM] - Getting Challenge settings for shop.airedale-60249.bjdazure.tech ...
  VERBOSE: [6/4/2024 1:55:55 PM] - Modifiying chart eshop-certificate to complete certificate request ...
  Release "eshop-certificates" has been upgraded. Happy Helming!
  NAME: eshop-certificates
  LAST DEPLOYED: Tue Jun  4 13:55:56 2024
  NAMESPACE: default
  STATUS: deployed
  REVISION: 6
  TEST SUITE: None

  > kubectl --namespace aks-istio-ingress get certs
  NAME                           READY   SECRET              AGE
  airedale-60249-bjdazure-tech   True    istio-ingress-tls   116s
  
  >kubectl --namespace aks-istio-ingress get secrets
  NAME                                                               TYPE                 DATA   AGE
  istio-ingress-tls                                                  kubernetes.io/tls    2      120s
  sh.helm.release.v1.asm-igx-aks-istio-ingressgateway-external.v73   helm.sh/release.v1   1      6m41s
  sh.helm.release.v1.asm-igx-aks-istio-ingressgateway-external.v74   helm.sh/release.v1   1      110s

  > kubectl --namespace aks-istio-ingress get ingress
  No resources found in aks-istio-ingress namespace.
```

# Navigation
[Previous Section ⏪](./infrastructure.md) ‖ [Return to Main Index 🏠](../README.md) ‖ [Next Section ⏩](./build.md)
<p align="right">(<a href="#certificates">back to top</a>)</p>
