output "compartment" {
  value = module.compartment.compartments
}

output "subnets" {
  value       = module.network.subnets
  description = "The subnet OCID"
}

output "hub_network" {
  description = "The hub subnets OCIDs"
  value       = module.network.hub_network
}

output "vcn" {
  value = module.network.vcn_id
}

output "hub_vcn_cidr" {
  value = var.vcn_cidr_block
}

output "hub_public_subnet_cidr" {
  value = var.public_subnet_cidr_block
}

output "hub_private_subnet_cidr" {
  value = var.private_subnet_cidr_block
}

output "drg_id" {
  value = module.network.drg_id
}

output "identity_domain" {
  value = module.identity.domain
}

output "stream_id" {
  value = module.logging.stream_id
}

output "key_id" {
  value = module.security.key_id
}

output "bucket" {
  value = module.logging.bucket
}

output "default_group_id" {
  value = module.logging.log_group_id
}

output "vault_id" {
  value = module.security.vault_id
}

output "rpc_id" {
  value = module.network-extension.rpc_id
}

output "default_log_group_id" {
  value = module.logging.log_group_id
}

output "shared_tools_network" {
  value = {
    "shared_tools_vcn_id" : var.enable_shared_tools == true ? module.shared_tools[0].vcn_id : ""
    "shared_tools_vcn_cidr" : var.enable_shared_tools == true ? var.shared_tools_vcn_cidr_block : ""
    "shared_tools_vcn_subnets" : var.enable_shared_tools == true ? module.shared_tools[0].subnets : {}
  }
}
