module "vcn_cluster1" {
  source                  = "./modules/network"
  compartment_id          = var.compartment_id
  vcn_name                = "vcn_cluster1"
  vcn_dns_label           = "vcncls1"
  network_cidrs           = var.cls1_network_cidrs
  remote_cluster_vcn_cidr = lookup(var.cls2_network_cidrs, "MAIN-VCN-CIDR")
  rpc_name                = "cluster1_to_cluster2"


  providers = {
    oci = oci.cls1
  }

}


module "vcn_cluster2" {
  source                  = "./modules/network"
  compartment_id          = var.compartment_id
  vcn_name                = "vcn_cluster2"
  vcn_dns_label           = "vcncls2"
  network_cidrs           = var.cls2_network_cidrs
  rpc_name                = "cluster2_to_cluster1"
  remote_cluster_vcn_cidr = lookup(var.cls1_network_cidrs, "MAIN-VCN-CIDR")
  providers = {
    oci = oci.cls2
  }

}


module "oke_cluster1" {
  source                  = "./modules/oke"
  compartment_id          = var.compartment_id
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