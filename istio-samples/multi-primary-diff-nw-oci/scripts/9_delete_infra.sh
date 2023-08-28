#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)


# Remove network peering
cluster1_rpc_id=`oci --profile $cluster1_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0].id' --raw-output`
cluster2_rpc_id=`oci --profile $cluster2_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0].id' --raw-output`

cluster1_rpc_status=`oci --profile $cluster1_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0]."peering-status"' --raw-output`
cluster2_rpc_status=`oci --profile $cluster2_oci_profile_name network remote-peering-connection list --compartment-id $compartment_id --query 'data[0]."peering-status"' --raw-output`

if [ -n "$cluster1_rpc_id" ];then   
    echo -e "\n\e[0;32m${bold}Removing remote peering connection ${normal}"
    oci --profile $cluster1_oci_profile_name network remote-peering-connection delete  --remote-peering-connection-id $cluster1_rpc_id --force
fi

if [ -n "$cluster2_rpc_id" ];then   
    echo -e "\n\e[0;32m${bold}Removing remote peering connection ${normal}"
    oci --profile $cluster2_oci_profile_name network remote-peering-connection delete  --remote-peering-connection-id $cluster2_rpc_id --force
fi

sleep 60

#Run Terraform
echo -e "\n\e[0;32m${bold}Running Terraform Scripts ${normal}"
cd ../terraform
terraform init
terraform destroy -auto-approve

rm ${script_path}/../terraform/modules/oke/generated/config


