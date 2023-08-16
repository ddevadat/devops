<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_security_list.security_list_spoke](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID ID | `string` | n/a | yes |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | n/a | <pre>list(object({<br>    destination      = string,<br>    protocol         = string,<br>    description      = string,<br>    destination_type = string,<br>  }))</pre> | n/a | yes |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | n/a | <pre>list(object({<br>    protocol                 = string,<br>    source                   = string,<br>    description              = string,<br>    source_type              = string,<br>    tcp_source_port_min      = optional(number),<br>    tcp_source_port_max      = optional(number),<br>    tcp_destination_port_min = optional(number),<br>    tcp_destination_port_max = optional(number),<br>    icmp_type                = optional(number),<br>    icmp_code                = optional(number),<br>    udp_source_port_min      = optional(number),<br>    udp_source_port_max      = optional(number),<br>    udp_destination_port_min = optional(number),<br>    udp_destination_port_max = optional(number),<br>  }))</pre> | n/a | yes |
| <a name="input_security_list_display_name"></a> [security\_list\_display\_name](#input\_security\_list\_display\_name) | Security List Display Name | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | VCN OCID ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_list_id"></a> [security\_list\_id](#output\_security\_list\_id) | The OCID of the Security List |
<!-- END_TF_DOCS -->    