#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)

echo -e "\n\e[0;32m${bold}Uninstalling Istio ${ISTIO_VERSION}.. ${normal}"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"
export PATH="${ISTIO_INSTALL_LOCATION}/istio-${ISTIO_VERSION}/bin:$PATH"
istioctl uninstall --context="${CTX_CLUSTER1}" -y --purge
istioctl uninstall --context="${CTX_CLUSTER2}" -y --purge





