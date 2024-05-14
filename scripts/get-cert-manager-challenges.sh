#!/bin/bash

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
  exit 1
fi

ingresses=`kubectl --namespace aks-istio-ingress get ingress -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'`

for ingress in ${ingresses[*]}; 
do 
  echo Getting Challenge settings for ${ingress}

  HOST=`kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].host}'`
  CHALLENGE_PATH=`kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].http.paths[0].path}'`
  CHALLENGE_SERVICE_NAME=`kubectl --namespace aks-istio-ingress get ingress ${ingress} -o jsonpath='{.spec.rules[*].http.paths[0].backend.service.name}'`
  
  echo Update eshop-k8s-extensions Helm Chart Values.yaml file with the following values for ${HOST}:
  echo -e "\t SERVICE_NAME: ${CHALLENGE_SERVICE_NAME}"
  echo -e "\t CHALLENGE_PATH: ${CHALLENGE_PATH}"
  echo 
done

echo 'Please re-run `task configs` to update the Helm Chart values.yaml file with the challenge settings.'