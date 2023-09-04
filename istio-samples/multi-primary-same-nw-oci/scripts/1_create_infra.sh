#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)

merge_kubeconfig(){
    kubeconfig_loc=$1
    pushd $kubeconfig_loc
    for cluster in oke_cluster1 oke_cluster2; do
    current=$(KUBECONFIG=$cluster kubectl config current-context)  
    KUBECONFIG=$cluster kubectl config rename-context $current $cluster  
    done  
    KUBECONFIG=./oke_cluster1:./oke_cluster2 kubectl config view --flatten > ./config
    popd  
}

#Run Terraform
echo -e "\n\e[0;32m${bold}Running Terraform Scripts ${normal}"
cd ../terraform
terraform init
terraform apply -auto-approve





merge_kubeconfig "${script_path}/../terraform/modules/oke/generated"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"

echo -e "\n\e[0;32m${bold}Getting Cluster 1 Node Status ${normal}"
kubectl --context=${CTX_CLUSTER1} get nodes

echo -e "\n\e[0;32m${bold}Getting Cluster 2 Node Status ${normal}"
kubectl --context=${CTX_CLUSTER2} get nodes


