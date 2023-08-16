# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
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

variable "home_compartment_id" {
  type        = string
  description = "the OCID of the compartment where the environment will be created. In general, this should be the Landing zone parent compartment."
}

variable "is_baseline_deploy" {
  type        = bool
  description = "TagNameSpace Optimization: Enable this flag to disable dependent module TagNameSpace Tag Creation."
}

variable "shared_tools_compartment_id" {
  type        = string
  description = "Shared Tools Compartment OCID"
}

# -----------------------------------------------------------------------------
# Network Variables
# -----------------------------------------------------------------------------
variable "hub_public_subnet_cidr_block" {
  type        = string
  description = "Hub Public Subnet CIDR Block."
}

variable "hub_private_subnet_cidr_block" {
  type        = string
  description = "Hub Private Subnet CIDR Block."
}

variable "shared_tools_vcn_cidr_block" {
  type        = string
  description = "Shared Tools VCN CIDR Block."
}

variable "shared_tools_subnet1_cidr_block" {
  type        = string
  description = "shared tools Subnet1 CIDR Block."
  default     = ""
}

variable "shared_tools_subnet2_cidr_block" {
  type        = string
  description = "shared tools Subnet2 CIDR Block."
  default     = ""
}

variable "shared_tools_subnet3_cidr_block" {
  type        = string
  description = "shared tools Subnet3 CIDR Block."
  default     = ""
}

variable "shared_tools_subnet4_cidr_block" {
  type        = string
  description = "shared tools Subnet4 CIDR Block."
  default     = ""
}

variable "shared_tools_vcn_display_name" {
  type        = string
  description = "Shared Tools VCN Display Name"
  default     = ""
}
variable "shared_tools_vcn_dns_label" {
  description = "A DNS label for the Shared Tools VCN"
  type        = string
  default     = ""
}
variable "shared_tools_subnet1_dns_label" {
  description = "A DNS label for the Shared Tools VCN's Subnet1"
  type        = string
  default     = ""
}
variable "shared_tools_subnet2_dns_label" {
  description = "A DNS label for the Shared Tools VCN's Subnet2"
  type        = string
  default     = ""
}
variable "shared_tools_subnet3_dns_label" {
  description = "A DNS label for the Shared Tools VCN's Subnet3"
  type        = string
  default     = ""
}
variable "shared_tools_subnet4_dns_label" {
  description = "A DNS label for the Shared Tools VCN's Subnet4"
  type        = string
  default     = ""
}

variable "drg_id" {
  type        = string
  description = "DRG OCID."
}

variable "enable_tools_internet_gateway" {
  type        = string
  default     = false
  description = "Option to enable true and Disable false."
}
variable "enable_tools_nat_gateway" {
  type        = string
  default     = true
  description = "Option to enable true and Disable false."
}

variable "enable_tools_service_gateway" {
  type        = string
  default     = true
  description = "Option to enable true and Disable false."
}

variable "igw_tools_check" {
  type    = list(string)
  default = [""]
}

variable "nat_gw_tools_check" {
  type    = list(string)
  default = [""]
}

variable "service_gw_tools_check" {
  type    = list(string)
  default = [""]
}

variable "add_ssh_to_security_list" {
  type        = bool
  description = "Add SSH tcp port to Hub security list"
  default     = false
}

# -----------------------------------------------------------------------------
# Network Extension Variables
# -----------------------------------------------------------------------------
variable "ipsec_connection_static_routes" {
  type = list(string)
}

variable "enable_vpn_or_fastconnect" {
  type        = string
  description = "Option to enable VPN or FASTCONNECT service. Options are NONE, VPN, FASTCONNECT."
}

variable "enable_vpn_on_environment" {
  type = bool
}

variable "enable_fastconnect_on_environment" {
  type = bool
}

variable "customer_onprem_ip_cidr" {
  type = list(string)
}

# -----------------------------------------------------------------------------
# Workload Network Variables
# -----------------------------------------------------------------------------
variable "shared_tools_workload_subnets_cidr_blocks" {
  type        = list(string)
  description = "A list of subnets cidr blocks in additional workload stack that needs access to shared tools compartment"
}
