
variable "environment_prefix" {
  type        = string
  description = "the 1 character string representing the environment eg. P (prod), N (non-prod), D, T, U"
}
variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "region" {
  type        = string
  description = "The OCI region"
}

variable "is_baseline_deploy" {
  type        = bool
  description = "TagNameSpace Optimization: Enable this flag to disable dependent module TagNameSpace Tag Creation."
}

variable "home_compartment_id" {
  type        = string
  description = "the OCID of the compartment where the environment will be created. In general, this should be the Landing zone parent compartment."
}

variable "workload_spoke_vcn_cidr" {
  description = "The list of IPv4 CIDR blocks the VCN will use."
  type        = string
}
variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}
variable "workload_public_spoke_subnet_web_cidr_block" {
  type        = string
  description = "Workload Enivornment Spoke VCN CIDR Block."
}
variable "workload_private_spoke_subnet_app_cidr_block" {
  type        = string
  description = "Workload Enivornment Spoke VCN CIDR Block."
}
variable "workload_private_spoke_subnet_db_cidr_block" {
  type        = string
  description = "Workload Enivornment Spoke VCN CIDR Block."
}
variable "workload_private_spoke_subnet_k8s_ep_cidr_block" {
  type        = string
  description = "Workload Enivornment Spoke VCN CIDR Block."
}
variable "workload_private_spoke_subnet_worker_cidr_block" {
  type        = string
  description = "Workload Enivornment Spoke VCN CIDR Block."
}

variable "workload_public_spoke_subnet_web_dns_label" {
  description = "A DNS label for the VCN Subnet, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}
variable "workload_private_spoke_subnet_app_dns_label" {
  description = "A DNS label for the VCN Subnet, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}
variable "workload_private_spoke_subnet_db_dns_label" {
  description = "A DNS label for the VCN Subnet, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}
variable "workload_private_spoke_subnet_k8s_dns_label" {
  description = "A DNS label for the VCN Subnet, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}
variable "workload_private_spoke_subnet_wrkr_dns_label" {
  description = "A DNS label for the VCN Subnet, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}

variable "nat_gateway_display_name" {
  description = "(Updatable) Name of NAT Gateway. Does not have to be unique."
  type        = string
}

variable "service_gateway_display_name" {
  description = "(Updatable) Name of Service Gateway. Does not have to be unique."
  type        = string
}

variable "internet_gateway_display_name" {
  description = "(Updatable) Name of Service Gateway. Does not have to be unique."
  type        = string
}

variable "workload_compartment_name" {
  type        = string
  description = "The name of the workload compartment by default OCI-ELZ-<Workload Name>-<Region>."
  default     = "OCI-ELZ-Workload1"
}
variable "enable_nat_gateway_spoke" {
  type = bool
}
variable "enable_service_gateway_spoke" {
  type = bool
}
variable "enable_internet_gateway_spoke" {
  type = bool
}

variable "nat_gw_spoke_check" {
  type    = list(string)
  default = [""]
}

variable "service_gw_spoke_check" {
  type    = list(string)
  default = [""]
}

variable "internet_gw_spoke_check" {
  type    = list(string)
  default = [""]
}

variable "drg_id" {
  type = string
}
variable "hub_public_subnet_cidr_block" {
  type = string
}
variable "hub_private_subnet_cidr_block" {
  type = string
}
variable "workload_compartment_id" {
  type = string
}
variable "vcn_display_name" {
  type        = string
  description = "Workload Expansion Spoke VCN Display Name"
}
variable "workload_public_spoke_subnet_web_display_name" {
  type        = string
  description = "Workload Expansion Spoke Web Subnet Display Name."
}
variable "workload_private_spoke_subnet_app_display_name" {
  type        = string
  description = "Workload Expansion Spoke App Subnet Display Name."
}
variable "workload_private_spoke_subnet_db_display_name" {
  type        = string
  description = "Workload Expansion Spoke Db Subnet Display Name."
}
variable "workload_private_spoke_subnet_k8s_display_name" {
  type        = string
  description = "Workload Expansion K8S EP Subnet Display Name."
}
variable "workload_private_spoke_subnet_wrkr_display_name" {
  type        = string
  description = "Workload Expansion K8S Worker Subnet Display Name."
}
variable "route_table_display_name" {
  type        = string
  description = "Workload Expansion Spoke Route Table Name Disply Name."
}

variable "public_route_table_display_name" {
  type        = string
  description = "Workload Expansion Spoke Public Route Table Name Disply Name."
}

variable "security_list_display_name" {
  type        = string
  description = "Workload Expansion Spoke Security List Name Disly Name."
}

variable "security_list_k8s_display_name" {
  type        = string
  description = "Workload Expansion Spoke K8S Security List Name Disly Name."
}

variable "enable_vpn_or_fastconnect" {}
variable "enable_vpn_on_environment" {}
variable "ipsec_connection_static_routes" {}
variable "customer_onprem_ip_cidr" {}
