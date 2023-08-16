variable "egress_rules" {
  type = list(object({
    destination      = string,
    protocol         = string,
    description      = string,
    destination_type = string,
  }))
}

variable "ingress_rules" {
  type = list(object({
    protocol                 = string,
    source                   = string,
    description              = string,
    source_type              = string,
    tcp_source_port_min      = optional(number),
    tcp_source_port_max      = optional(number),
    tcp_destination_port_min = optional(number),
    tcp_destination_port_max = optional(number),
    icmp_type                = optional(number),
    icmp_code                = optional(number),
    udp_source_port_min      = optional(number),
    udp_source_port_max      = optional(number),
    udp_destination_port_min = optional(number),
    udp_destination_port_max = optional(number),
  }))
}

variable "compartment_id" {
  type        = string
  description = "Compartment OCID ID"
}
variable "vcn_id" {
  type        = string
  description = "VCN OCID ID"
}
variable "security_list_display_name" {
  type        = string
  description = "Security List Display Name"
}
