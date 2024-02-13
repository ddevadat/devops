log() { echo "$1" >&2; }
export PATH=/tmp/istio-1.19.0/istio-1.19.0/bin:$PATH
ANSIBLE_INVENTORY_LOCATION=~/inventory/env/dev/