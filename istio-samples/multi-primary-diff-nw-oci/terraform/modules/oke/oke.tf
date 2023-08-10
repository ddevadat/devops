resource "oci_containerengine_cluster" "oke_cluster" {
    #Required
    compartment_id = var.compartment_id
    kubernetes_version = var.kubernetes_version
    name = var.cluster_name
    vcn_id = var.vcn_id

    #Optional
    cluster_pod_network_options {
        #Required
        cni_type = var.cni_type == "flannel" ? "FLANNEL_OVERLAY" : "OCI_VCN_IP_NATIVE"
    }
    endpoint_config {

        #Optional
        is_public_ip_enabled = var.control_plane_is_public
        subnet_id = var.control_plane_subnet_id
    }
    options {

        #Optional
        kubernetes_network_config {
            pods_cidr = var.pods_cidr
        }
        service_lb_subnet_ids = [var.lb_subnet_id]
    }
    type = var.cluster_type
}