set -euo pipefail
source ./cluster_2_env.sh
bold=$(tput bold)
normal=$(tput sgr0)
script_path=$(pwd)
file_path="cluster_2_services.lst"

for jobName in `cat $file_path`
do
   ansible-playbook -i ${ANSIBLE_INVENTORY_LOCATION}/hosts ../ansible/deploy_core_service.yml --extra-vars "chart_path=../helm_charts/$jobName release_name=$jobName role_name=helm-deploy"
done