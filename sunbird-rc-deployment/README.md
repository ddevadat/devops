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

## Deployment

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

## Post deployment

Update DNS configuration

Find the external ip of the load balancer of the istio ingress gateway from cluster1

```
kubectl get svc istio-ingressgateway -n istio-system
NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                                      AGE
istio-ingressgateway   LoadBalancer   YYYYYY          XXXXXXXX      15021:31283/TCP,80:30393/TCP,443:30301/TCP   14d

```

Update your domain name with A record.

If you dont have dns domain, you can update the domain name in your local /etc/hosts file

## Verfication

Run the below health check api on the registry service.

```
for i in {1..100}; do  curl -k https://<domain_name>/registry/health && sleep 1 && echo "**************"; done

sample output

{"id":"sunbird-rc.registry.health","ver":"1.0","ets":1707875456458,"params":{"resmsgid":"","msgid":"d2687014-2942-41e0-9f58-ee28af888e74","err":"","status":"SUCCESSFUL","errmsg":""},"responseCode":"OK","result":{"name":"sunbirdrc-registry-api","healthy":true,"checks":[{"name":"sunbird.certificate-api.service","healthy":true,"err":"SIGNATURE_ENABLED","errmsg":"false"},{"name":"sunbird.encryption.service","healthy":true,"err":"ENCRYPTION_ENABLED","errmsg":"false"},{"name":"sunbird.file-storage.service","healthy":true,"err":"","errmsg":""},{"name":"sunbird.notification.service","healthy":true,"err":"NOTIFICATION_ENABLED","errmsg":"false"},{"name":"sunbird.elastic.service","healthy":true,"err":"","errmsg":""},{"name":"sunbird.signature.service","healthy":true,"err":"SIGNATURE_ENABLED","errmsg":"false"},{"name":"sunbird.keycloak.service","healthy":true,"err":"","errmsg":""}]}}

```

Scale the replica to 0 for registry in any cluster.

```
kubectl -n dev edit deployment.apps/registry

```

The previously executed health check curl should display the results.