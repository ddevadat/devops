resource "oci_containerengine_cluster" "oke_cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id

  #Optional
  cluster_pod_network_options {
    #Required
    cni_type = var.cni_type == "flannel" ? "FLANNEL_OVERLAY" : "OCI_VCN_IP_NATIVE"
  }
  endpoint_config {

    #Optional
    is_public_ip_enabled = var.control_plane_is_public
    subnet_id            = var.control_plane_subnet_id
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


resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.node_pool_name
  node_shape         = var.node_pool_shape

  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.ADs.availability_domains

      content {
        availability_domain = placement_configs.value.name
        subnet_id           = var.worker_node_subnet_id
      }
    }
    size = var.node_pool_size
    node_pool_pod_network_option_details {
      #Required
      cni_type = var.cni_type == "flannel" ? "FLANNEL_OVERLAY" : "OCI_VCN_IP_NATIVE"

      #Optional
      pod_subnet_ids    = [var.worker_node_subnet_id]
    }
  }

  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      ocpus         = var.node_pool_node_shape_config_ocpus
      memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = lookup(data.oci_core_images.node_pool_images.images[0], "id")
    boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
  }

  initial_node_labels {
    key   = "name"
    value = var.node_pool_name
  }

}


# Local kubeconfig for when using Terraform locally. Not used by Oracle Resource Manager
resource "local_file" "oke_kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.oke.content
  filename = "${path.module}/generated/${var.cluster_name}"
  file_permission = "0644"
}