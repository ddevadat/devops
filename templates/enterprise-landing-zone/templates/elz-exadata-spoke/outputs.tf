
output "spoke_vcn" {
  value = module.workload_spoke_vcn.vcn
}

output "subnets" {
  value = {
    (var.workload_private_spoke_subnet_lb_display_name)     = module.workload_spoke_subnet.subnets[var.workload_private_spoke_subnet_lb_display_name]
    (var.workload_private_spoke_subnet_app_display_name)    = module.workload_spoke_subnet.subnets[var.workload_private_spoke_subnet_app_display_name]
    (var.workload_private_spoke_subnet_client_display_name) = module.workload_spoke_subnet.subnets[var.workload_private_spoke_subnet_client_display_name]
    (var.workload_private_spoke_subnet_backup_display_name) = module.workload_spoke_subnet.subnets[var.workload_private_spoke_subnet_backup_display_name]
  }
  description = "The spoke subnets OCIDs"
}

output "subnet_cidrs" {
  value = {
    (var.workload_private_spoke_subnet_lb_display_name)     = var.workload_private_spoke_subnet_lb_cidr_block
    (var.workload_private_spoke_subnet_app_display_name)    = var.workload_private_spoke_subnet_app_cidr_block
    (var.workload_private_spoke_subnet_client_display_name) = var.workload_private_spoke_subnet_client_cidr_block
    (var.workload_private_spoke_subnet_backup_display_name) = var.workload_private_spoke_subnet_backup_cidr_block
  }
  description = "The spoke subnets CIDR blocks"
}
