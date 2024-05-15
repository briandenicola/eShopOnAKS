SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure")

export APP_NAME=$(terraform -chdir=${INFRA_PATH} output -raw APP_NAME)
export AKS_RG=$(terraform -chdir=${INFRA_PATH} output -raw AKS_RESOURCE_GROUP)
export APP_RG=$(terraform -chdir=${INFRA_PATH} output -raw APP_RESOURCE_GROUP)
export KEYVAULT_NAME=$(terraform -chdir=${INFRA_PATH} output -raw KEYVAULT_NAME)
export AKS=$(terraform -chdir=${INFRA_PATH} output -raw AKS_CLUSTER_NAME)
export ACR_NAME=$(terraform -chdir=${INFRA_PATH} output -raw ACR_NAME)
