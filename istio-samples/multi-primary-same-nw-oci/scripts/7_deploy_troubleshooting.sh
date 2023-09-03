#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)
mkdir -p ${script_path}/generated


create_sample_namespace() {
    CTX_CLUSTER=$1
    if kubectl --context="${CTX_CLUSTER}" get namespace uninjected-sample &> /dev/null; then
    echo "Namespace sample exists."
    else
    echo "Namespace sample does not exist. Creating namespace uninjected-sample"
    kubectl create --context="${CTX_CLUSTER}" namespace uninjected-sample
    fi    
}

deploy_sample_application() {

pushd ${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n uninjected-sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n uninjected-sample
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v1 -n uninjected-sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v2 -n uninjected-sample
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/sleep/sleep.yaml -n uninjected-sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/sleep/sleep.yaml -n uninjected-sample


popd
}


echo -e "\n\e[0;32m${bold}Creating sample namespace .. ${normal}"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"
create_sample_namespace $CTX_CLUSTER1
create_sample_namespace $CTX_CLUSTER2

echo -e "\n\e[0;32m${bold}Deploying sample application .. ${normal}"
deploy_sample_application







