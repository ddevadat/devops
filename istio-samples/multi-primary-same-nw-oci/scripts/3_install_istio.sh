#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)
mkdir -p ${script_path}/generated


configure_istio_multiprimary(){
cluster_name=$1
cluster_ctx=$2

# Set the default network
kubectl --context="${cluster_ctx}" get namespace istio-system && \

# Configure as a primary

cat <<EOF > ${script_path}/generated/${cluster_name}.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: ${cluster_name}
      network: network1
EOF

istioctl install -y  --set profile=minimal --context=${cluster_ctx} -f ${script_path}/generated/${cluster_name}.yaml

}


echo -e "\n\e[0;32m${bold}Configuring Istio ${ISTIO_VERSION}.. ${normal}"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"
configure_istio_multiprimary cluster1 $CTX_CLUSTER1
configure_istio_multiprimary cluster2 $CTX_CLUSTER2



