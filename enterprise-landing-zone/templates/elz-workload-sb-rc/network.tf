
module "workload_expansion_spoke" {
  source             = "../elz-spoke-sb-rc"
  environment_prefix = var.environment_prefix
  tenancy_ocid       = var.tenancy_ocid
  region             = var.region
  is_baseline_deploy = var.is_baseline_deploy

  home_compartment_id = var.home_compartment_id
  #Spoke VCN Variables
  workload_spoke_vcn_cidr = var.workload_spoke_vcn_cidr
  vcn_dns_label           = var.vcn_dns_label
  vcn_display_name        = var.vcn_display_name != "" ? var.vcn_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-VCN-${local.region_key[0]}"
  #Spoke VCN Subnet Variables
  workload_public_spoke_subnet_web_display_name   = var.workload_public_spoke_subnet_web_display_name != "" ? var.workload_public_spoke_subnet_web_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SUB-${local.region_key[0]}-WEB"
  workload_private_spoke_subnet_app_display_name  = var.workload_private_spoke_subnet_app_display_name != "" ? var.workload_private_spoke_subnet_app_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SUB-${local.region_key[0]}-APP"
  workload_private_spoke_subnet_db_display_name   = var.workload_private_spoke_subnet_db_display_name != "" ? var.workload_private_spoke_subnet_db_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SUB-${local.region_key[0]}-DB"
  workload_private_spoke_subnet_k8s_display_name  = var.workload_private_spoke_subnet_k8s_display_name != "" ? var.workload_private_spoke_subnet_k8s_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SUB-${local.region_key[0]}-K8S"
  workload_private_spoke_subnet_wrkr_display_name = var.workload_private_spoke_subnet_wrkr_display_name != "" ? var.workload_private_spoke_subnet_wrkr_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SUB-${local.region_key[0]}-WRK"


  workload_public_spoke_subnet_web_cidr_block     = var.workload_public_spoke_subnet_web_cidr_block
  workload_private_spoke_subnet_app_cidr_block    = var.workload_private_spoke_subnet_app_cidr_block
  workload_private_spoke_subnet_db_cidr_block     = var.workload_private_spoke_subnet_db_cidr_block
  workload_private_spoke_subnet_k8s_ep_cidr_block = var.workload_private_spoke_subnet_k8s_ep_cidr_block
  workload_private_spoke_subnet_worker_cidr_block = var.workload_private_spoke_subnet_worker_cidr_block


  workload_public_spoke_subnet_web_dns_label   = var.workload_public_spoke_subnet_web_dns_label
  workload_private_spoke_subnet_app_dns_label  = var.workload_private_spoke_subnet_app_dns_label
  workload_private_spoke_subnet_db_dns_label   = var.workload_private_spoke_subnet_db_dns_label
  workload_private_spoke_subnet_k8s_dns_label  = var.workload_private_spoke_subnet_k8s_dns_label
  workload_private_spoke_subnet_wrkr_dns_label = var.workload_private_spoke_subnet_wrkr_dns_label

  #VCN Gateway Variables
  enable_nat_gateway_spoke        = var.enable_nat_gateway_spoke
  enable_service_gateway_spoke    = var.enable_service_gateway_spoke
  enable_internet_gateway_spoke    = var.enable_internet_gateway_spoke
  nat_gateway_display_name        = var.nat_gateway_display_name != "" ? var.nat_gateway_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-NAT-${local.region_key[0]}"
  service_gateway_display_name    = var.service_gateway_display_name != "" ? var.service_gateway_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-SGW-${local.region_key[0]}"
  internet_gateway_display_name    = var.internet_gateway_display_name != "" ? var.internet_gateway_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-IGW-${local.region_key[0]}"

  route_table_display_name        = var.route_table_display_name != "" ? var.route_table_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-RTPRV-${local.region_key[0]}"
  public_route_table_display_name = var.public_route_table_display_name != "" ? var.public_route_table_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-RTPUB-${local.region_key[0]}"
  security_list_display_name      = var.security_list_display_name != "" ? var.security_list_display_name : "OCI-ELZ-${var.workload_prefix}-EXP-SPK-Security-List"
  drg_id                          = var.drg_id
  hub_public_subnet_cidr_block    = var.hub_public_subnet_cidr_block
  hub_private_subnet_cidr_block   = var.hub_private_subnet_cidr_block
  workload_compartment_id         = module.workload_compartment.compartment_id

  customer_onprem_ip_cidr        = var.customer_onprem_ip_cidr
  enable_vpn_on_environment      = var.enable_vpn_on_environment
  enable_vpn_or_fastconnect      = var.enable_vpn_or_fastconnect
  ipsec_connection_static_routes = var.ipsec_connection_static_routes

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}
