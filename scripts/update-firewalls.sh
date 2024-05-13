#!/bin/bash

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
  exit 1
fi

# check if resource group variable is defined else exit
source ./scripts/setup-env.sh
echo $RG | grep -i warning >> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Resource group not defined by terraform. Please create the environment by running 'task up'. Exiting."
    exit 1
fi

ip=$(curl -sS http://checkip.amazonaws.com/)

echo "Updating Azure Container Registry firewall to allow access from $ip"
az acr network-rule add --name ${ACR_NAME} --resource-group ${RG} --ip-address $ip

echo "Updating KeyVault firewall to allow access from $ip"
az keyvault network-rule add --name ${KEYVAULT_NAME} --resource-group ${RG} --ip-address $ip

echo "Updating AKS firewall to allow access from $ip"
az aks update -n ${AKS} -g ${RG} --api-server-authorized-ip-ranges $ip