# Install Sunbird RC on OKE

Steps to orchestrate [Sunbird-RC](https://docs.sunbirdrc.dev/learn/readme) on OKE cluster.

<!-- ![dual-screenshot](images/mutli-primary.svg) -->

## Prerequisites

- Oracle Enterprise Landing Zone
- Provision an Operator vm in the app subnet
- Provision a db vm in the db subnet
- oci cli ,ansible, helm, kubectl installed on operator vm


## Create ansible inventory and private variables

```
clone the repo in operator vm
update the variables in private_repo/ansible/inv/dev/Core/secrets.yaml
update the db vm ip address in private_repo/ansible/inv/dev/Core/hosts
update the private ssh key in the operator vm /home/ubuntu/secrets/deployer_ssh_key
update the oke access config in /home/ubuntu/secrets/k8s.yaml
export OCI_CLI_AUTH=instance_principal
update the path in scripts/env.sh
ANSIBLE_INVENTORY_LOCATION=<repo_dir>/private_repo/ansible/inv/dev/Core/

```

## Provision Postgres

Provision postgres db

```
cd scripts
./provision-postgres.sh
./postgres-data-update.sh

```

## Bootstrap OKE 

Bootstrap oke cluster

```
cd scripts
./bootstrap_k8s.sh

```

## Install sunbird-rc helm chart 

sunbird-rc helm chart 

```
cd scripts
./deploy_sunbird-rc.sh

```