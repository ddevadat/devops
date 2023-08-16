# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "region" {
  type        = string
  description = "The OCI region"
}

variable "environment_prefix" {
  type        = string
  description = "the 1 character string representing the environment eg. P (prod), N (non-prod), D, T, U"
}

variable "home_compartment_id" {
  type        = string
  description = "the OCID of the compartment where the environment will be created. In general, this should be the Landing zone parent compartment."
}

variable "is_baseline_deploy" {
  type        = bool
  description = "TagNameSpace Optimization: Enable this flag to disable dependent module TagNameSpace Tag Creation."
}

variable "enable_shared_tools" {
  type        = bool
  description = "Set to true to enable a management tools compartment which hosts few of the tools that are used to manage workloads across the environments."
  default     = false
}

# -----------------------------------------------------------------------------
# Network Variables
# -----------------------------------------------------------------------------
variable "enable_internet_gateway_hub" {
  type        = string
  default     = "false"
  description = "Option to enable true and Disable false."
}
variable "enable_nat_gateway_hub" {
  type        = string
  default     = "false"
  description = "Option to enable true and Disable false."
}

variable "enable_service_gateway_hub" {
  type        = string
  default     = "false"
  description = "Option to enable true and Disable false."
}

variable "igw_hub_check" {
  type = list(string)
}

variable "nat_gw_hub_check" {
  type = list(string)
}

variable "service_gw_hub_check" {
  type = list(string)
}

variable "network_compartment_id" {
  type        = string
  description = "Network Compartment OCID"
}

variable "vcn_cidr_block" {
  type        = string
  description = "VCN CIDR Block."
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "Hub: Public Subnet CIDR Block."
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "Hub: Private Subnet CIDR Block."
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
variable "additional_workload_subnets_cidr_blocks" {
  type        = list(string)
  description = "A list of subnets cidr blocks in additional workload stack"
  default     = []
}

variable "shared_tools_subnets_cidr_blocks" {
  type        = list(string)
  description = "A list of subnets cidr blocks of shared tools VCN"
  default     = []
}
