module "vcn_cluster1" {
  source                  = "./modules/network"
  compartment_id          = var.compartment_id
  vcn_name                = "vcn_cluster1"
  vcn_dns_label           = "vcncls1"
  network_cidrs           = var.cls1_network_cidrs

  providers = {
    oci = oci.cls1
  }

}

module "oke_cluster1" {
  source                  = "./modules/oke"
  compartment_id          = var.compartment_id
  tenancy_id              = var.tenancy_id
  cluster_name            = "oke_cluster1"
  vcn_id                  = module.vcn_cluster1.vcn_id
  control_plane_subnet_id = module.vcn_cluster1.subnet_k8s_ep_id
  worker_node_subnet_id   = module.vcn_cluster1.subnet_worker_id
  lb_subnet_id            = module.vcn_cluster1.subnet_lb_id
  pods_cidr               = lookup(var.cls1_network_cidrs, "SUBNET_WORKER_NODE-CIDR")
  providers = {
    oci = oci.cls1
  }

}

module "oke_cluster2" {
  source                  = "./modules/oke"
  compartment_id          = var.compartment_id
  tenancy_id              = var.tenancy_id
  cluster_name            = "oke_cluster2"
  vcn_id                  = module.vcn_cluster1.vcn_id
  control_plane_subnet_id = module.vcn_cluster1.subnet_k8s_ep_id
  worker_node_subnet_id   = module.vcn_cluster1.subnet_worker_id
  lb_subnet_id            = module.vcn_cluster1.subnet_lb_id
  pods_cidr               = lookup(var.cls1_network_cidrs, "SUBNET_WORKER_NODE-CIDR")
  providers = {
    oci = oci.cls1
  }

}

