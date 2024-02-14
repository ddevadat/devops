set -euo pipefail
source ./cluster_2_env.sh
bold=$(tput bold)
normal=$(tput sgr0)
script_path=$(pwd)
ansible-playbook -i ${ANSIBLE_INVENTORY_LOCATION}/hosts ../ansible/istio-gw.yml
