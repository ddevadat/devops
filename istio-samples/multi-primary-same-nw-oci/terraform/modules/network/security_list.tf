resource "oci_core_security_list" "k8s_api_ep_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "seclist-KubernetesAPIendpoint"

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Kubernetes worker to Kubernetes API endpoint communication."
    tcp_options {
      max = local.k8s_api_port_number
      min = local.k8s_api_port_number
    }
  }


  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    description = "Bastion to Kubernetes API endpoint communication"
    tcp_options {
      max = local.k8s_api_port_number
      min = local.k8s_api_port_number
    }
  }

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Kubernetes worker to control plane communication."
    tcp_options {
      max = local.k8s_control_plane_port_number
      min = local.k8s_control_plane_port_number
    }
  }


  ingress_security_rules {
    protocol    = local.icmp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Path Discovery"
    icmp_options {
      type = local.icmp_options_type
      code = local.icmp_options_code
    }
  }

  egress_security_rules {
    protocol         = local.tcp_protocol_number
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    description      = "Allow Kubernetes control plane to communicate with OKE."
    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }

  egress_security_rules {
    protocol    = local.icmp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Path Discovery."
    icmp_options {
      type = local.icmp_options_type
      code = local.icmp_options_code
    }
  }

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "All traffic to worker nodes"
  }

}


####


resource "oci_core_security_list" "worker_node_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "seclist-workernodes"

  ingress_security_rules {
    protocol    = local.all_protocols
    source      = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Allow pods on one worker node to communicate with pods on other worker nodes."

  }


  ingress_security_rules {
    protocol    = local.icmp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
    description = "Path Discovery"
    icmp_options {
      type = local.icmp_options_type
      code = local.icmp_options_code
    }
  }

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
    description = "TCP access from Kubernetes Control Plane"

  }



  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "ALL-CIDR")
    description = "(optional) Allow inbound SSH traffic to managed nodes."
    tcp_options {
      max = local.ssh_port_number
      min = local.ssh_port_number
    }
  }

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_LB-CIDR")
    tcp_options {
      max = 30514
      min = 30514
    }
  }

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_LB-CIDR")
    tcp_options {
      max = 31689
      min = 31689
    }
  }

  ingress_security_rules {
    protocol    = local.tcp_protocol_number
    source      = lookup(var.network_cidrs, "SUBNET_LB-CIDR")
    tcp_options {
      max = 30816
      min = 30816
    }
  }

  egress_security_rules {
    protocol    = local.all_protocols
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    description = "Allow pods on one worker node to communicate with pods on other worker nodes."
  }

  egress_security_rules {
    protocol    = local.icmp_protocol_number
    destination = lookup(var.network_cidrs, "ALL-CIDR")
    description = "ICMP Access from Kubernetes Control Plane."
    icmp_options {
      type = local.icmp_options_type
      code = local.icmp_options_code
    }
  }

  egress_security_rules {
    protocol    = local.icmp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
    description = "Path Discovery."
    icmp_options {
      type = local.icmp_options_type
      code = local.icmp_options_code
    }
  }

  egress_security_rules {
    protocol         = local.tcp_protocol_number
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    description      = "Allow worker nodes to communicate with OKE."
  }

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
    description = "Kubernetes worker to Kubernetes API endpoint communication."
    tcp_options {
      max = local.k8s_api_port_number
      min = local.k8s_api_port_number
    }
  }

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_K8S_API_EP-CIDR")
    description = "Kubernetes worker to control plane communication."
    tcp_options {
      max = local.k8s_control_plane_port_number
      min = local.k8s_control_plane_port_number
    }
  }

  egress_security_rules {
    protocol    = local.all_protocols
    destination = lookup(var.network_cidrs, "ALL-CIDR")
    description = "Allow worker nodes to communicate with internet."
  }


}


###


resource "oci_core_security_list" "lb_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "seclist-loadbalancers"

  ingress_security_rules {
    protocol = local.tcp_protocol_number
    source   = lookup(var.network_cidrs, "ALL-CIDR")
    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }

  ingress_security_rules {
    protocol = local.tcp_protocol_number
    source   = lookup(var.network_cidrs, "ALL-CIDR")
    tcp_options {
      max = local.http_port_number
      min = local.http_port_number
    }
  }



  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    tcp_options {
      min = 30514
      max = 30514
    }
  }

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    tcp_options {
      min = 31689
      max = 31689
    }
  }

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "SUBNET_WORKER_NODE-CIDR")
    tcp_options {
      min = 30816
      max = 30816
    }
  }

}