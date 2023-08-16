locals {

  vcn_shared_tools = {
    vcn_name          = var.shared_tools_vcn_display_name != "" ? var.shared_tools_vcn_display_name : "OCI-ELZ-VCN-${var.environment_prefix}-TOOLS-${local.region_key[0]}"
    vcn_dns_label     = var.shared_tools_vcn_dns_label != "" ? var.shared_tools_vcn_dns_label : "toolsdns"
    subnet1_dns_label = var.shared_tools_subnet1_dns_label != "" ? var.shared_tools_subnet1_dns_label : "subnet1dns"
    subnet2_dns_label = var.shared_tools_subnet2_dns_label != "" ? var.shared_tools_subnet2_dns_label : "subnet2dns"
    subnet3_dns_label = var.shared_tools_subnet3_dns_label != "" ? var.shared_tools_subnet3_dns_label : "subnet3dns"
    subnet4_dns_label = var.shared_tools_subnet4_dns_label != "" ? var.shared_tools_subnet4_dns_label : "subnet4dns"
  }

  shared_tools_workload_subnets_cidr_blocks = var.shared_tools_workload_subnets_cidr_blocks != [] ? var.shared_tools_workload_subnets_cidr_blocks : []
  hub_cidr_blocks                           = [var.hub_public_subnet_cidr_block, var.hub_private_subnet_cidr_block]

  shared_tools_public_route_rules_options = {
    route_rules_igw = {
      for index, route in local.igw_tools_check : "igw-rule-${index}" => {
        network_entity_id = module.tools_internet_gateway[0].internet_gw_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_nat_spoke = {
      for index, route in local.nat_gw_tools_check : "nat-gw-rule-${index}" => {
        network_entity_id = module.tools_nat_gateway[0].nat_gw_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_srvc_gw_spoke = {
      for index, route in local.service_gw_tools_check : "service-gw-rule-${index}" => {
        network_entity_id = module.tools_service_gateway[0].service_gw_id
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
    route_rules_shared_tools = {
      for index, route in local.shared_tools_workload_subnets_cidr_blocks : "workload-rule-${index}" => {
        network_entity_id = var.drg_id
        destination       = route
        destination_type  = "CIDR_BLOCK"
      }
    }
    route_rules_hub = {
      for index, route in local.hub_cidr_blocks : "hub-rule-${index}" => {
        network_entity_id = var.drg_id
        destination       = route
        destination_type  = "CIDR_BLOCK"
      }
    }
  }

  shared_tools_route_rules = {
    route_rules = merge(local.shared_tools_public_route_rules_options.route_rules_igw,
      local.shared_tools_public_route_rules_options.route_rules_nat_spoke,
      local.shared_tools_public_route_rules_options.route_rules_srvc_gw_spoke,
      local.shared_tools_public_route_rules_options.route_rules_vpn,
      local.shared_tools_public_route_rules_options.route_rules_fastconnect,
      local.shared_tools_public_route_rules_options.route_rules_shared_tools,
    local.shared_tools_public_route_rules_options.route_rules_hub)
  }

  tools_internet_gateway = {
    vcn_id                        = oci_core_vcn.vcn_shared_tools.id
    internet_gateway_display_name = "OCI-ELZ-IGW-${var.environment_prefix}-TOOLS"
  }

  tools_nat_gateway = {
    vcn_id                   = oci_core_vcn.vcn_shared_tools.id
    nat_gateway_display_name = "OCI-ELZ-NGW-${var.environment_prefix}-TOOLS"
  }

  tools_service_gateway = {
    vcn_id                       = oci_core_vcn.vcn_shared_tools.id
    service_gateway_display_name = "OCI-ELZ-SGW-${var.environment_prefix}-TOOLS"
  }

  ipsec_connection_static_routes = var.enable_vpn_or_fastconnect == "VPN" && var.enable_vpn_on_environment ? var.ipsec_connection_static_routes : []
  customer_onprem_ip_cidr        = var.enable_vpn_or_fastconnect == "FASTCONNECT" ? var.customer_onprem_ip_cidr : []

  igw_tools_check        = var.enable_tools_internet_gateway ? var.igw_tools_check : []
  nat_gw_tools_check     = var.enable_tools_nat_gateway ? var.nat_gw_tools_check : []
  service_gw_tools_check = var.enable_tools_service_gateway ? var.service_gw_tools_check : []

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
}

#Get Service Gateway For Region .
data "oci_core_services" "service_gateway" {
  filter {
    name   = "name"
    values = [".*Object.*Storage"]
    regex  = true
  }
}

resource "oci_core_vcn" "vcn_shared_tools" {
  cidr_blocks    = [var.shared_tools_vcn_cidr_block]
  compartment_id = var.shared_tools_compartment_id
  display_name   = local.vcn_shared_tools.vcn_name
  dns_label      = local.vcn_shared_tools.vcn_dns_label
  is_ipv6enabled = false
}

resource "oci_core_route_table" "tools_route_table" {
  count          = 4
  compartment_id = var.shared_tools_compartment_id
  vcn_id         = oci_core_vcn.vcn_shared_tools.id
  display_name   = "OCI-ELZ-RTPRV-${var.environment_prefix}-TOOLS${count.index}"
  dynamic "route_rules" {
    for_each = local.shared_tools_route_rules.route_rules
    content {
      description       = route_rules.key
      network_entity_id = route_rules.value.network_entity_id
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
    }
  }
}

resource "oci_core_subnet" "tools_private_subnet1" {
  cidr_block                 = var.shared_tools_subnet1_cidr_block
  display_name               = "OCI-ELZ-SUB-${var.environment_prefix}-TOOLS-${local.region_key[0]}001"
  dns_label                  = local.vcn_shared_tools.subnet1_dns_label
  compartment_id             = var.shared_tools_compartment_id
  prohibit_public_ip_on_vnic = true
  vcn_id                     = oci_core_vcn.vcn_shared_tools.id
  route_table_id             = oci_core_route_table.tools_route_table[0].id
  security_list_ids          = toset([oci_core_security_list.tools_security_list.id])
}

resource "oci_core_subnet" "tools_private_subnet2" {
  count                      = var.shared_tools_subnet2_cidr_block != "" ? 1 : 0
  cidr_block                 = var.shared_tools_subnet2_cidr_block
  display_name               = "OCI-ELZ-SUB-${var.environment_prefix}-TOOLS-${local.region_key[0]}002"
  dns_label                  = local.vcn_shared_tools.subnet2_dns_label
  compartment_id             = var.shared_tools_compartment_id
  prohibit_public_ip_on_vnic = true
  vcn_id                     = oci_core_vcn.vcn_shared_tools.id
  route_table_id             = oci_core_route_table.tools_route_table[1].id
  security_list_ids          = toset([oci_core_security_list.tools_security_list.id])
}

resource "oci_core_subnet" "tools_private_subnet3" {
  count                      = var.shared_tools_subnet3_cidr_block != "" ? 1 : 0
  cidr_block                 = var.shared_tools_subnet3_cidr_block
  display_name               = "OCI-ELZ-SUB-${var.environment_prefix}-TOOLS-${local.region_key[0]}003"
  dns_label                  = local.vcn_shared_tools.subnet3_dns_label
  compartment_id             = var.shared_tools_compartment_id
  prohibit_public_ip_on_vnic = true
  vcn_id                     = oci_core_vcn.vcn_shared_tools.id
  route_table_id             = oci_core_route_table.tools_route_table[2].id
  security_list_ids          = toset([oci_core_security_list.tools_security_list.id])
}

resource "oci_core_subnet" "tools_private_subnet4" {
  count                      = var.shared_tools_subnet4_cidr_block != "" ? 1 : 0
  cidr_block                 = var.shared_tools_subnet4_cidr_block
  display_name               = "OCI-ELZ-SUB-${var.environment_prefix}-TOOLS-${local.region_key[0]}004"
  dns_label                  = local.vcn_shared_tools.subnet4_dns_label
  compartment_id             = var.shared_tools_compartment_id
  prohibit_public_ip_on_vnic = true
  vcn_id                     = oci_core_vcn.vcn_shared_tools.id
  route_table_id             = oci_core_route_table.tools_route_table[3].id
  security_list_ids          = toset([oci_core_security_list.tools_security_list.id])
}

module "tools_internet_gateway" {
  count                         = var.enable_tools_internet_gateway ? 1 : 0
  source                        = "../../modules/internet-gateway"
  network_compartment_id        = var.shared_tools_compartment_id
  vcn_id                        = oci_core_vcn.vcn_shared_tools.id
  internet_gateway_display_name = local.tools_internet_gateway.internet_gateway_display_name
}

module "tools_nat_gateway" {
  count                    = var.enable_tools_nat_gateway ? 1 : 0
  source                   = "../../modules/nat-gateway"
  network_compartment_id   = var.shared_tools_compartment_id
  vcn_id                   = oci_core_vcn.vcn_shared_tools.id
  nat_gateway_display_name = local.tools_nat_gateway.nat_gateway_display_name
}

module "tools_service_gateway" {
  count                        = var.enable_tools_service_gateway ? 1 : 0
  source                       = "../../modules/service-gateway"
  network_compartment_id       = var.shared_tools_compartment_id
  vcn_id                       = oci_core_vcn.vcn_shared_tools.id
  service_gateway_display_name = local.tools_service_gateway.service_gateway_display_name
}

resource "oci_core_default_security_list" "tools_default_security_list_locked_down" {
  manage_default_resource_id = oci_core_vcn.vcn_shared_tools.default_security_list_id
}

resource "oci_core_security_list" "tools_security_list" {
  compartment_id = var.shared_tools_compartment_id
  vcn_id         = oci_core_vcn.vcn_shared_tools.id
  display_name   = "OCI-ELZ-${var.environment_prefix}-Tools-Security-List"

  egress_security_rules {
    destination      = local.security_list_egress.destination
    protocol         = local.security_list_egress.protocol
    description      = local.security_list_egress.description
    destination_type = local.security_list_egress.destination_type
  }
  ingress_security_rules {
    protocol    = local.security_list_ingress.protocol
    source      = local.security_list_ingress.source
    description = local.security_list_ingress.description
    source_type = local.security_list_ingress.source_type
  }
  dynamic "ingress_security_rules" {
    for_each = var.add_ssh_to_security_list ? [1] : []
    content {
      protocol    = local.security_list_ingress_ssh.protocol
      source      = local.security_list_ingress_ssh.source
      description = local.security_list_ingress_ssh.description
      source_type = local.security_list_ingress_ssh.source_type
      tcp_options {
        max = local.security_list_ingress_ssh.tcp_port
        min = local.security_list_ingress_ssh.tcp_port
      }
    }
  }
}

