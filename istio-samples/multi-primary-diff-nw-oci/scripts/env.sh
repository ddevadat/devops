log() { echo "$1" >&2; }

cluster1_oci_profile_name="REGION1"
cluster2_oci_profile_name="REGION2"
ISTIO_VERSION=${ISTIO_VERSION:=1.19.0}
ISTIO_INSTALL_LOCATION=/tmp/istio-${ISTIO_VERSION}
ISTIO_NAMESPACE=istio-system
CTX_CLUSTER1=oke_cluster1
CTX_CLUSTER2=oke_cluster2
cluster1_region="${cluster1_region:?cluster1_region env variable must be specified}"
cluster2_region="${cluster2_region:?cluster2_region env variable must be specified}"
compartment_id="${compartment_id:?compartment_id env variable must be specified}"
