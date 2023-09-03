data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}


resource "oci_core_virtual_network" "vcn" {
  cidr_block     = lookup(var.network_cidrs, "MAIN-VCN-CIDR")
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "vcn_igw" {
  compartment_id = var.compartment_id
  display_name   = "internet-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_nat_gateway" "vcn_nat" {
  compartment_id = var.compartment_id
  display_name   = "nat-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_service_gateway" "vcn_sgw" {
  compartment_id = var.compartment_id
  display_name   = "service-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }

}

resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "private-routetable"

  route_rules {
    destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.vcn_sgw.id
  }

  route_rules {
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.vcn_nat.id
  }

  route_rules {
    destination       = var.remote_cluster_vcn_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.drg.id
    description = "To Cluster 2"
  }

}


resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "public-routetable"

  route_rules {
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.vcn_igw.id
  }

}



resource "oci_core_subnet" "k8s_api_ep_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
  display_name               = "KubernetesAPIendpoint"
  security_list_ids          = [oci_core_security_list.k8s_api_ep_security_list.id]
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.vcn.id
  route_table_id             = oci_core_route_table.public_rt.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false
}


resource "oci_core_subnet" "worker_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
  display_name               = "workernodes"
  security_list_ids          = [oci_core_security_list.worker_node_security_list.id]
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.vcn.id
  route_table_id             = oci_core_route_table.private_rt.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "lb_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET_LB-CIDR")
  display_name               = "loadbalancers"
  security_list_ids          = [oci_core_security_list.lb_security_list.id]
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.vcn.id
  route_table_id             = oci_core_route_table.public_rt.id
  dhcp_options_id            = oci_core_virtual_network.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false
}


resource "oci_core_drg" "drg" {
    #Required
    compartment_id = var.compartment_id
    display_name = "drg"
}


resource "oci_core_drg_attachment" "drg_attachment" {
    drg_id = oci_core_drg.drg.id
    network_details {
        id = oci_core_virtual_network.vcn.id
        type = "VCN"
    }
}

resource "oci_core_remote_peering_connection" "remote_peering_connection" {
    compartment_id = var.compartment_id
    drg_id = oci_core_drg.drg.id
    display_name = var.rpc_name
}