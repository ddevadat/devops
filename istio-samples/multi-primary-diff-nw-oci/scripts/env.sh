log() { echo "$1" >&2; }

cluster1_oci_profile_name="REGION1"
cluster2_oci_profile_name="REGION2"
cluster1_region="${cluster1_region:?cluster1_region env variable must be specified}"
cluster2_region="${cluster2_region:?cluster2_region env variable must be specified}"
compartment_id="${compartment_id:?compartment_id env variable must be specified}"
