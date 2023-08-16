output "drg_id" {
  value = module.drg.drg_id
}

output "vcn_id" {
  value = oci_core_vcn.vcn_hub_network.id
}

output "subnets" {
  value = {
    (oci_core_subnet.hub_public_subnet.display_name)  = oci_core_subnet.hub_public_subnet.id
    (oci_core_subnet.hub_private_subnet.display_name) = oci_core_subnet.hub_private_subnet.id
  }
  description = "The subnet OCID"
}

output "hub_network" {
  value = {
    "hub_vcn_id" : oci_core_vcn.vcn_hub_network.id
    "hub_vcn_cidr" : var.vcn_cidr_block
    "hub_vcn_subnets" : {
      (oci_core_subnet.hub_public_subnet.display_name)  = oci_core_subnet.hub_public_subnet.id
      (oci_core_subnet.hub_private_subnet.display_name) = oci_core_subnet.hub_private_subnet.id
    }
  }
}
