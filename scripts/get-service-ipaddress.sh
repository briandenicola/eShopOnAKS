#!/bin/bash

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
  exit 1
fi

export IP=`kubectl --namespace aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo ${IP}