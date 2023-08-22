variable "vcn_name" {
  description = "VCN name"
  default     = "vcn"
}

variable "vcn_dns_label" {
  description = "VCN label"
  default     = "vcn"
}


variable "compartment_id" {
    description = "Compartment OCID"
}

variable "network_cidrs" {
  type = map(string)
}

variable "remote_network_cidrs" {
  type = map(string)
}

variable "remote_cluster_vcn_cidr" {
  description = "Remote cluster vcn cidr"
}

variable "rpc_name" {
  type = string
}