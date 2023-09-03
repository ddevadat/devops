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


echo -e "\n\e[0;32m${bold}Making remote peering connection ${normal}"
cluster1_rpc_id=`oci --profile $cluster1_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0].id' --raw-output`
cluster2_rpc_id=`oci --profile $cluster2_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0].id' --raw-output`

cluster1_rpc_status=`oci --profile $cluster1_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0]."peering-status"' --raw-output`
cluster2_rpc_status=`oci --profile $cluster2_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0]."peering-status"' --raw-output`

if [ $cluster1_rpc_status != "PEERED" ];then   
    oci --profile $cluster1_oci_profile_name network remote-peering-connection connect --peer-id $cluster2_rpc_id --peer-region-name $cluster2_region  --remote-peering-connection-id $cluster1_rpc_id
fi

if [ $cluster2_rpc_status != "PEERED" ];then   
    oci --profile $cluster2_oci_profile_name network remote-peering-connection connect --peer-id $cluster1_rpc_id --peer-region-name $cluster1_region  --remote-peering-connection-id $cluster2_rpc_idfi
fi


merge_kubeconfig "${script_path}/../terraform/modules/oke/generated"
export KUBECONFIG="${script_path}/../terraform/modules/oke/generated/config"


echo -e "\n\e[0;32m${bold}Getting Cluster 1 Node Status ${normal}"
kubectl --context=${CTX_CLUSTER1} get nodes

echo -e "\n\e[0;32m${bold}Getting Cluster 2 Node Status ${normal}"
kubectl --context=${CTX_CLUSTER2} get nodes


