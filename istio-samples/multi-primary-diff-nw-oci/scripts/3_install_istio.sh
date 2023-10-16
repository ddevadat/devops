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
kubectl --context="${cluster_ctx}" label namespace istio-system topology.istio.io/network=network1

# Configure as a primary

cat <<EOF > ${script_path}/generated/${cluster_name}.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    defaultConfig:
      proxyMetadata:
        # Enable basic DNS proxying
        ISTIO_META_DNS_CAPTURE: "true"
        # Enable automatic address allocation, optional
        ISTIO_META_DNS_AUTO_ALLOCATE: "true"
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: ${cluster_name}
      network: network1
EOF

istioctl install -y  --set profile=minimal --context=${cluster_ctx} -f ${script_path}/generated/${cluster_name}.yaml

# Install the east-west gateway
${script_path}/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster ${cluster_name} --network network1 | \
    istioctl --context="${cluster_ctx}" install -y -f -



pushd ${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}

# Expose services in cluster
kubectl --context="${cluster_ctx}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml

popd

}


echo -e "\n\e[0;32m${bold}Configuring Istio ${ISTIO_VERSION}.. ${normal}"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"
configure_istio_multiprimary cluster1 $CTX_CLUSTER1
configure_istio_multiprimary cluster2 $CTX_CLUSTER2



