# Install Sunbird RC on OKE

Steps to orchestrate [Sunbird-RC](https://docs.sunbirdrc.dev/learn/readme) on OKE cluster.

<!-- ![dual-screenshot](images/mutli-primary.svg) -->

## Prerequisites

- `oci` CLI
- `kubectl`
- `terraform`
- `make`
- `helm` CLI

### Add section for creating terraform variables
```
TBD
```

## Set Env Variables

```
export cluster1_region="<region_1_identifier>
export cluster2_region="<region_2_identifier>"
export compartment_id="<compartment_ocid>"

```

## Configure OCI cli for two regions

Get the [region](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm#About) identifier for OCI

```
## REGION1
[REGION1]
user=ocid1.user.oc1..xxxxxxxx
fingerprint=xxxx
tenancy=ocid1.tenancy.oc1..xxxxxx
region=<region_identifier>
key_file=/home/ubuntu/api-key/api-key.pem

### REGION2
[REGION2]
user=ocid1.user.oc1..xxxxxxxx
fingerprint=xxxx
tenancy=ocid1.tenancy.oc1..xxxxxx
region=<region_identifier>
key_file=<path_to_api_key_file>
```

## Provision Infra

This will create two oke cluster in two different region , with remote peering

```
./scripts/create_infra.sh

```
