
output "workload" {
  value = {
    workload = {
      environment_prefix = var.environment_prefix
      compartment_name   = local.workload_compartment.name
      compartment_id     = module.workload_compartment.compartment_id
      bastion_id         = var.enable_bastion ? module.bastion[0].bastion_ocid : null
      subnet_ids         = module.exadata_workload_expansion_spoke.subnets
      subnet_cidrs       = module.exadata_workload_expansion_spoke.subnet_cidrs
    }
    spoke_vcn = module.exadata_workload_expansion_spoke.spoke_vcn
  }
}
