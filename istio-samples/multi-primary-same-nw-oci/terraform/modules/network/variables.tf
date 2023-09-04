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

