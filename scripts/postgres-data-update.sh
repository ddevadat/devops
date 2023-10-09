set -euo pipefail
source ./env.sh
bold=$(tput bold)
normal=$(tput sgr0)
script_path=$(pwd)
ansible-playbook -i ${ANSIBLE_INVENTORY_LOCATION}/hosts ../ansible/postgresql-data-update.yml
