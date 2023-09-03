#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)



delete_sample_namespace() {
    CTX_CLUSTER=$1
    if kubectl --context="${CTX_CLUSTER}" get namespace uninjected-sample &> /dev/null; then
    echo "Namespace sample exists."
    kubectl delete --context="${CTX_CLUSTER}" namespace uninjected-sample
    else
    echo "Namespace sample does not exist."
    fi    
}

delete_sample_application() {

pushd ${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/
kubectl delete --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n uninjected-sample
kubectl delete --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n uninjected-sample
kubectl delete --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v1 -n uninjected-sample
kubectl delete --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v2 -n uninjected-sample
kubectl delete --context="${CTX_CLUSTER1}" \
    -f samples/sleep/sleep.yaml -n uninjected-sample
kubectl delete --context="${CTX_CLUSTER2}" \
    -f samples/sleep/sleep.yaml -n uninjected-sample


popd
}



export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"

echo -e "\n\e[0;32m${bold}Deleting sample application .. ${normal}"
delete_sample_application

echo -e "\n\e[0;32m${bold}Deleting sample namespace .. ${normal}"
delete_sample_namespace $CTX_CLUSTER1
delete_sample_namespace $CTX_CLUSTER2









