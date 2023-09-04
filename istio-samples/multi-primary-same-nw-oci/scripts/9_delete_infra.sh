#!/bin/bash

set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)

script_path=$(pwd)


#Run Terraform
echo -e "\n\e[0;32m${bold}Running Terraform Scripts ${normal}"
cd ../terraform
terraform init
terraform destroy -auto-approve

rm ${script_path}/../terraform/modules/oke/generated/config


