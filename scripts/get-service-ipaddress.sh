#!/bin/bash

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
  exit 1
fi

# check if resource group variable is defined else exit
source ./setup-env.sh
echo $RG | grep -i warning >> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Resource group not defined by terraform. Please create the environment by running 'task up'. Exiting."
    exit 1
fi

export IP=`kubectl get svc aks-istio-ingressgateway-external -n aks-istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo ${IP}