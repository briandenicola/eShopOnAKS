#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure")

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
  exit 1
fi
export KEYVAULT_NAME=$(terraform -chdir=${INFRA_PATH} output -raw KEYVAULT_NAME)
export APP_RG=$(terraform -chdir=${INFRA_PATH} output -raw APP_RESOURCE_GROUP)

export AKS=$(terraform -chdir=${INFRA_PATH} output -raw AKS_CLUSTER_NAME)
export AKS_RG=$(terraform -chdir=${INFRA_PATH} output -raw AKS_RESOURCE_GROUP)
export ACR_NAME=$(terraform -chdir=${INFRA_PATH} output -raw ACR_NAME)

ip=$(curl -sS http://checkip.amazonaws.com/)

echo "Updating Azure Container Registry (${ACR_NAME}) firewall to allow access from $ip"
az acr network-rule add --name ${ACR_NAME} --resource-group ${AKS_RG} --ip-address $ip

echo "Updating KeyVault (${KEYVAULT_NAME}) firewall to allow access from $ip"
az keyvault network-rule add --name ${KEYVAULT_NAME} --resource-group ${APP_RG} --ip-address $ip

echo "Updating AKS (${AKS}) firewall to allow access from $ip"
az aks update -n ${AKS} -g ${AKS_RG} --api-server-authorized-ip-ranges $ip