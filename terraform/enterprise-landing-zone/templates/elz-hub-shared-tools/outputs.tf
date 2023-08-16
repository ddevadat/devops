output "drg_id" {
  value = var.drg_id
}

output "vcn_id" {
  value = oci_core_vcn.vcn_shared_tools.id
}

output "subnets" {
  value = {
    "subnet1" = oci_core_subnet.tools_private_subnet1.id
    "subnet2" = var.shared_tools_subnet2_cidr_block != "" ? oci_core_subnet.tools_private_subnet2[0].id : ""
    "subnet3" = var.shared_tools_subnet3_cidr_block != "" ? oci_core_subnet.tools_private_subnet3[0].id : ""
    "subnet4" = var.shared_tools_subnet4_cidr_block != "" ? oci_core_subnet.tools_private_subnet4[0].id : ""
  }
  description = "The tools subnets OCID"
}
