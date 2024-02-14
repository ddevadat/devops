# Demo: Install Sunbird-RC in active-active deployment across different regions

Steps to orchestrate service mesh with [Sunbird-RC](https://rc.sunbird.org/learn/readme) across two different OKE clusters.

![architecture](images/multicluster-2.jpg)

## Prerequisites

- [Install Multi-Primary on different networks](../istio-samples/multi-primary-diff-nw-oci/)

## Assumptions

For this deployment , we going to deploy stateful applications like postgres, keycloak, elastic search , filestorage only on cluster1

## Ansible inventory

create two inventory folders 

```
mkdir -p ~/inventory/env/dev/cluster1
mkdir -p ~/inventory/env/dev/cluster2
```

Copy the private inventory template 

```
cp istio-multicluster-setup/devops/private_repo/ansible/inv/dev/Core/* ~/inventory/env/dev/cluster1
cp istio-multicluster-setup/devops/private_repo/ansible/inv/dev/Core/* ~/inventory/env/dev/cluster2

```
update the inventory variables as per the requirement in secrets.yaml

### Deployment

Execute the below scripts.

```
cd istio-multicluster-setup/devops/sunbird-rc-deployment
./1_bootstrap_k8s_cluster_1.sh
./1_bootstrap_k8s_cluster_2.sh

./2_install_istio_cluster_1.sh
./2_install_istio_cluster_2.sh

./3_install_istio_gw_cluster_1.sh
./3_install_istio_gw_cluster_2.sh

./4_deploy_sunbird-rc_cluster1.sh
./4_deploy_sunbird-rc_cluster2.sh

```