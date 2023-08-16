module "shared_tools" {
  count                             = var.enable_shared_tools ? 1 : 0
  source                            = "../elz-hub-shared-tools"
  tenancy_ocid                      = var.tenancy_ocid
  region                            = var.region
  environment_prefix                = var.environment_prefix
  home_compartment_id               = var.home_compartment_id
  is_baseline_deploy                = var.is_baseline_deploy
  shared_tools_compartment_id       = module.compartment.compartments.shared_tools.id
  hub_public_subnet_cidr_block      = var.public_subnet_cidr_block
  hub_private_subnet_cidr_block     = var.private_subnet_cidr_block
  shared_tools_vcn_cidr_block       = var.shared_tools_vcn_cidr_block
  shared_tools_subnet1_cidr_block   = var.shared_tools_subnet1_cidr_block
  shared_tools_subnet2_cidr_block   = var.shared_tools_subnet2_cidr_block
  shared_tools_subnet3_cidr_block   = var.shared_tools_subnet3_cidr_block
  shared_tools_subnet4_cidr_block   = var.shared_tools_subnet4_cidr_block
  shared_tools_vcn_display_name     = var.shared_tools_vcn_display_name
  shared_tools_vcn_dns_label        = var.shared_tools_vcn_dns_label
  shared_tools_subnet1_dns_label    = var.shared_tools_subnet1_dns_label
  shared_tools_subnet2_dns_label    = var.shared_tools_subnet2_dns_label
  shared_tools_subnet3_dns_label    = var.shared_tools_subnet3_dns_label
  shared_tools_subnet4_dns_label    = var.shared_tools_subnet4_dns_label
  enable_tools_internet_gateway     = var.enable_tools_internet_gateway
  enable_tools_nat_gateway          = var.enable_tools_nat_gateway
  enable_tools_service_gateway      = var.enable_tools_service_gateway
  ipsec_connection_static_routes    = var.ipsec_connection_static_routes
  enable_vpn_or_fastconnect         = var.enable_vpn_or_fastconnect
  enable_vpn_on_environment         = var.enable_vpn_on_environment
  enable_fastconnect_on_environment = var.enable_fastconnect_on_environment
  customer_onprem_ip_cidr           = var.customer_onprem_ip_cidr

  shared_tools_workload_subnets_cidr_blocks = var.shared_tools_workload_subnets_cidr_blocks
  drg_id                                    = module.network.drg_id //module.drg.drg_id
  # igw_tools_check                           = [""]
  # nat_gw_tools_check                        = [""]
  # service_gw_tools_check                    = [""]

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}
