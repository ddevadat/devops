set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)
script_path=$(pwd)

# Deploy certificateapi
jobName=certificateapi
while IFS= read -r jobName; do

    ansible-playbook -i ${ANSIBLE_INVENTORY_LOCATION}/hosts ../ansible/deploy_core_service.yml --extra-vars "chart_path=../helm_charts/$jobName release_name=$jobName role_name=helm-deploy"

done < "services.lst"

