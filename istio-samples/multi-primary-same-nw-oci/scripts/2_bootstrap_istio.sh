#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)



create_plugin_ca_certificates(){
    cd ${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}
    mkdir -p certs
    cd certs
    make -f ../tools/certs/Makefile.selfsigned.mk root-ca
    make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts
    make -f ../tools/certs/Makefile.selfsigned.mk cluster2-cacerts
}

create_cacerts_secrets() {
    cluster_name=$1
    export KUBECONFIG=$2
    cd ${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}
    cd certs    
    create_istio_namespace ${2}

    if kubectl get secrets cacerts -n "$ISTIO_NAMESPACE" &> /dev/null; then
    echo "secrets cacerts exists. Deleting and recreating it"
    kubectl delete secrets cacerts -n "$ISTIO_NAMESPACE"  
    fi 
    kubectl create secret generic cacerts -n ${ISTIO_NAMESPACE} \
      --from-file=${cluster_name}/ca-cert.pem \
      --from-file=${cluster_name}/ca-key.pem \
      --from-file=${cluster_name}/root-cert.pem \
      --from-file=${cluster_name}/cert-chain.pem
}


create_istio_namespace() {
    export KUBECONFIG=$1
    if kubectl get namespace "$ISTIO_NAMESPACE" &> /dev/null; then
    echo "Namespace '$ISTIO_NAMESPACE' exists."
    else
    echo "Namespace '$ISTIO_NAMESPACE' does not exist. Creating namespace '$ISTIO_NAMESPACE'"
    kubectl create namespace $ISTIO_NAMESPACE
    fi    
}


echo -e "\n\e[0;32m${bold}Downloading Istio ${ISTIO_VERSION}.. ${normal}"
mkdir -p ${ISTIO_INSTALL_LOCATION}
cd ${ISTIO_INSTALL_LOCATION}
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"

echo -e "\n\e[0;32m${bold}Creating plugin ca certs ${normal}"
create_plugin_ca_certificates
cd $script_path
create_cacerts_secrets cluster1 "${script_path}/../terraform/modules/oke/generated/oke_cluster1"
create_cacerts_secrets cluster2 "${script_path}/../terraform/modules/oke/generated/oke_cluster2"




echo -e "\n\e[0;32m${bold}Installing secret to access remote cluster ${normal}"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
istioctl x create-remote-secret --context=${CTX_CLUSTER1} --name=cluster1 | kubectl apply -f - --context=${CTX_CLUSTER2}
istioctl x create-remote-secret --context=${CTX_CLUSTER2} --name=cluster2 | kubectl apply -f - --context=${CTX_CLUSTER1}





