#!/usr/bin/pwsh

[CmdletBinding(DefaultParameterSetName = 'Default')]
param()

$ingresses=$(kubectl --namespace aks-istio-ingress get ingress -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

foreach( $ingress in $ingresses) {
  Write-Output "Getting Challenge settings for ${ingress}"

  $HOST_NAME=$(kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].host}')
  $CHALLENGE_PATH=$(kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].http.paths[0].path}')
  $CHALLENGE_SERVICE_NAME=$(kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].http.paths[0].backend.service.name}')
  
  Write-Output "Update eshop-k8s-extensions Helm Chart Values.yaml file with the following values for ${HOST_NAME}:"
  Write-Output "`t SERVICE_NAME: ${CHALLENGE_SERVICE_NAME}"
  Write-Output "`t CHALLENGE_PATH: ${CHALLENGE_PATH}"
  Write-Output ""
}

Write-Output 'Please re-run `task configs` to update the Helm Chart values.yaml file with the challenge settings.'