set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)
script_path=$(pwd)
jobName=sunbird-rc
ansible-playbook -i ${ANSIBLE_INVENTORY_LOCATION}/hosts ../ansible/deploy_core_service.yml --extra-vars \"chart_path=../helm_charts/$jobName release_name=$jobName image_tag=${image_tag} image_name=${image_name} role_name=helm-deploy"
