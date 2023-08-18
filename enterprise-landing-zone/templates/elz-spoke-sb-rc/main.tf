######################################################################
#     Workload | Workload Expansion Spoke Network Configuration      #
######################################################################
locals {
  workload_nat_gw_spoke_check      = var.enable_nat_gateway_spoke == true ? var.nat_gw_spoke_check : []
  workload_service_gw_spoke_check  = var.enable_service_gateway_spoke == true ? var.service_gw_spoke_check : []
  workload_internet_gw_spoke_check = var.enable_internet_gateway_spoke == true ? var.internet_gw_spoke_check : []

  ipsec_connection_static_routes = var.enable_vpn_or_fastconnect == "VPN" && var.enable_vpn_on_environment ? var.ipsec_connection_static_routes : []
  customer_onprem_ip_cidr        = var.enable_vpn_or_fastconnect == "FASTCONNECT" ? var.customer_onprem_ip_cidr : []


  spoke_route_rules_options = {
    route_rules_default = {
      "hub-public-subnet" = {
        network_entity_id = var.drg_id
        destination       = var.hub_public_subnet_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      "hub-private-subnet" = {
        network_entity_id = var.drg_id
        destination       = var.hub_private_subnet_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      "spoke-route-target" = {
        network_entity_id = var.drg_id
        destination       = var.workload_spoke_vcn_cidr
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_nat_spoke = {
      for index, route in local.workload_nat_gw_spoke_check : "nat-gw-rule-${index}" => {
        network_entity_id = module.workload-spoke-nat-gateway[0].nat_gw_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_srvc_gw_spoke = {
      for index, route in local.workload_service_gw_spoke_check : "service-gw-rule-${index}" => {
        network_entity_id = module.workload-spoke-service-gateway[0].service_gw_id
        destination       = data.oci_core_services.service_gateway.services[0]["cidr_block"]
        destination_type  = "SERVICE_CIDR_BLOCK"

      }
    }
    route_rules_vpn = {
      for index, route in local.ipsec_connection_static_routes : "cpe-rule-${index}" => {
        network_entity_id = var.drg_id
        destination       = route
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_fastconnect = {
      for index, route in local.customer_onprem_ip_cidr : "fc-rule-${index}" => {
        network_entity_id = var.drg_id
        destination       = route
        destination_type  = "CIDR_BLOCK"
      }
    }
  }

  # spoke_public_route_rules_options = {
  #   route_rules_igw_spoke = {
  #     for index, route in local.workload_internet_gw_spoke_check : "internet-gw-rule-${index}" => {
  #       network_entity_id = module.workload-spoke-internet-gateway[0].internet_gw_id
  #       destination       = "0.0.0.0/0"
  #       destination_type  = "CIDR_BLOCK"
  #     }
  #   }
  # }
  # spoke_public_route_rules = {
  #   route_rules = merge(local.spoke_public_route_rules_options.route_rules_igw_spoke)
  # }

  spoke_route_rules = {
    route_rules = merge(local.spoke_route_rules_options.route_rules_default, local.spoke_route_rules_options.route_rules_nat_spoke, local.spoke_route_rules_options.route_rules_srvc_gw_spoke, local.spoke_route_rules_options.route_rules_fastconnect, local.spoke_route_rules_options.route_rules_vpn)
  }

  workload_expansion_subnet_map = {
    Workload-Spoke-App-Subnet = {
      name                       = var.workload_private_spoke_subnet_app_display_name
      description                = "App Subnet"
      dns_label                  = var.workload_private_spoke_subnet_app_dns_label
      cidr_block                 = var.workload_private_spoke_subnet_app_cidr_block
      prohibit_public_ip_on_vnic = true
    }
    Workload-Spoke-Db-Subnet = {
      name                       = var.workload_private_spoke_subnet_db_display_name
      description                = "DB Subnet"
      dns_label                  = var.workload_private_spoke_subnet_db_dns_label
      cidr_block                 = var.workload_private_spoke_subnet_db_cidr_block
      prohibit_public_ip_on_vnic = true
    }
    Workload-Spoke-K8s-Subnet = {
      name                       = var.workload_private_spoke_subnet_k8s_display_name
      description                = "K8S Subnet"
      dns_label                  = var.workload_private_spoke_subnet_k8s_dns_label
      cidr_block                 = var.workload_private_spoke_subnet_k8s_ep_cidr_block
      prohibit_public_ip_on_vnic = true
    }
    Workload-Spoke-Wrkr-Subnet = {
      name                       = var.workload_private_spoke_subnet_wrkr_display_name
      description                = "Worker Subnet"
      dns_label                  = var.workload_private_spoke_subnet_wrkr_dns_label
      cidr_block                 = var.workload_private_spoke_subnet_worker_cidr_block
      prohibit_public_ip_on_vnic = true
    }
    Workload-Spoke-Web-Subnet = {
      name                       = var.workload_private_spoke_subnet_web_display_name
      description                = "Web Subnet"
      dns_label                  = var.workload_private_spoke_subnet_web_dns_label
      cidr_block                 = var.workload_private_spoke_subnet_web_cidr_block
      prohibit_public_ip_on_vnic = true
    }
  }

  # workload_expansion_public_subnet_map = {
  #   Workload-Spoke-Web-Subnet = {
  #     name                       = var.workload_private_spoke_subnet_web_display_name
  #     description                = "Web Subnet"
  #     dns_label                  = var.workload_private_spoke_subnet_web_dns_label
  #     cidr_block                 = var.workload_private_spoke_subnet_web_cidr_block
  #     prohibit_public_ip_on_vnic = false
  #   }
  # }

  ip_protocols = {
    ICMP   = "1"
    TCP    = "6"
    UDP    = "17"
    ICMPv6 = "58"
  }
  security_list_ingress = {
    protocol    = local.ip_protocols.ICMP
    source      = "0.0.0.0/0"
    description = "All ICMP Taffic"
    source_type = "CIDR_BLOCK"
  }
  security_list_ingress_ssh = {
    protocol    = local.ip_protocols.TCP
    source      = "0.0.0.0/0"
    description = "SSH Traffic"
    source_type = "CIDR_BLOCK"
    tcp_port    = 22
  }
  security_list_egress = {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    description      = "All Traffic For All Port"
    destination_type = "CIDR_BLOCK"
  }

  security_list_egress_https = {
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    protocol         = local.ip_protocols.TCP
    description      = "Allow Kubernetes control plane to communicate with OKE"
    destination_type = "SERVICE_CIDR_BLOCK"
    tcp_destination_port_min = 443
    tcp_destination_port_max = 443
  }

  security_list_ingress_k8s_api = {
    protocol                 = local.ip_protocols.TCP
    source                   = var.workload_private_spoke_subnet_worker_cidr_block
    description              = "Kubernetes worker to Kubernetes API endpoint communication"
    source_type              = "CIDR_BLOCK"
    tcp_destination_port_min = 6443
    tcp_destination_port_max = 6443
  }
  security_list_ingress_k8s_cp = {
    protocol                 = local.ip_protocols.TCP
    source                   = var.workload_private_spoke_subnet_worker_cidr_block
    description              = "Kubernetes worker to control plane communication"
    source_type              = "CIDR_BLOCK"
    tcp_destination_port_min = 12250
    tcp_destination_port_max = 12250
  }

  security_list_ingress_k8s_path_discovery = {
    protocol    = local.ip_protocols.ICMP
    source      = var.workload_private_spoke_subnet_worker_cidr_block
    description = "Path Discovery"
    source_type = "CIDR_BLOCK"
    icmp_type   = 3
    icmp_code   = 4
  }
}
#Get Service Gateway For Region .
data "oci_core_services" "service_gateway" {
  filter {
    name   = "name"
    values = [".*Object.*Storage"]
    regex  = true
  }
}

data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

######################################################################
#                  Create Workload VCN Spoke                         #
######################################################################
module "workload_spoke_vcn" {
  source = "../../modules/vcn"

  vcn_cidrs           = [var.workload_spoke_vcn_cidr]
  compartment_ocid_id = var.workload_compartment_id
  vcn_display_name    = var.vcn_display_name
  vcn_dns_label       = var.vcn_dns_label
  enable_ipv6         = false

  providers = {
    oci = oci.home_region
  }
}
######################################################################
#          Create Workload VCN Spoke Security List                   #
######################################################################
module "workload_spoke_security_list" {
  source = "../../modules/security-list"

  compartment_id             = var.workload_compartment_id
  vcn_id                     = module.workload_spoke_vcn.vcn_id
  security_list_display_name = var.security_list_display_name

  egress_rules  = [local.security_list_egress]
  ingress_rules = [local.security_list_ingress] # , local.security_list_ingress_ssh
}

module "workload_spoke_k8s_security_list" {
  source = "../../modules/security-list"

  compartment_id             = var.workload_compartment_id
  vcn_id                     = module.workload_spoke_vcn.vcn_id
  security_list_display_name = var.security_list_k8s_display_name

  egress_rules  = [local.security_list_egress, local.security_list_egress_https]
  ingress_rules = [local.security_list_ingress_k8s_cp, local.security_list_ingress_k8s_api, local.security_list_ingress_k8s_path_discovery] # , local.security_list_ingress_ssh
}

######################################################################
#          Create Workload VCN Spoke Subnet                          #
######################################################################
module "workload_spoke_subnet" {
  source = "../../modules/subnet"

  subnet_map              = local.workload_expansion_subnet_map
  compartment_id          = var.workload_compartment_id
  vcn_id                  = module.workload_spoke_vcn.vcn_id
  subnet_route_table_id   = module.workload_spoke_route_table.route_table_id
  subnet_security_list_id = toset([module.workload_spoke_security_list.security_list_id])
}

# module "workload_spoke_public_subnet" {
#   source = "../../modules/subnet"

#   subnet_map              = local.workload_expansion_public_subnet_map
#   compartment_id          = var.workload_compartment_id
#   vcn_id                  = module.workload_spoke_vcn.vcn_id
#   subnet_route_table_id   = module.workload_spoke_route_table_public.route_table_id
#   subnet_security_list_id = toset([module.workload_spoke_security_list.security_list_id])
# }

######################################################################
#          Create Workload VCN Spoke Gateway                         #
######################################################################
module "workload-spoke-nat-gateway" {
  source                   = "../../modules/nat-gateway"
  count                    = var.enable_nat_gateway_spoke ? 1 : 0
  nat_gateway_display_name = var.nat_gateway_display_name
  network_compartment_id   = var.workload_compartment_id
  vcn_id                   = module.workload_spoke_vcn.vcn_id
}

module "workload-spoke-service-gateway" {
  source                       = "../../modules/service-gateway"
  count                        = var.enable_service_gateway_spoke ? 1 : 0
  network_compartment_id       = var.workload_compartment_id
  service_gateway_display_name = var.service_gateway_display_name
  vcn_id                       = module.workload_spoke_vcn.vcn_id
}

# module "workload-spoke-internet-gateway" {
#   source                        = "../../modules/internet-gateway"
#   count                         = var.enable_internet_gateway_spoke ? 1 : 0
#   network_compartment_id        = var.workload_compartment_id
#   internet_gateway_display_name = var.internet_gateway_display_name
#   vcn_id                        = module.workload_spoke_vcn.vcn_id
# }

######################################################################
#          Create Workload VCN Spoke Route Table                     #
######################################################################
module "workload_spoke_route_table" {
  source                   = "../../modules/route-table"
  compartment_id           = var.workload_compartment_id
  vcn_id                   = module.workload_spoke_vcn.vcn_id
  route_table_display_name = var.route_table_display_name
  route_rules              = local.spoke_route_rules.route_rules
}

# module "workload_spoke_route_table_public" {
#   source                   = "../../modules/route-table"
#   compartment_id           = var.workload_compartment_id
#   vcn_id                   = module.workload_spoke_vcn.vcn_id
#   route_table_display_name = var.public_route_table_display_name
#   route_rules              = local.spoke_public_route_rules.route_rules
# }

######################################################################
#          Attach Workload Spoke VCN to DRG                          #
######################################################################
# module "workload_spoke_vcn_drg_attachment" {
#   source                        = "../../modules/drg-attachment"
#   drg_id                        = var.drg_id
#   vcn_id                        = module.workload_spoke_vcn.vcn_id
#   drg_attachment_type           = "VCN"
#   drg_attachment_vcn_route_type = "VCN_CIDRS"
# }
