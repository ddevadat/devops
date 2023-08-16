locals {
  compartments_map = merge({
    "environment" : module.environment_compartment.compartment,
    "shared" : module.shared_infra_compartment.compartment,
    "network" : module.network_compartment.compartment,
    "security" : module.security_compartment.compartment,
    },
    var.enable_logging == true ? { "logging" : module.logging_compartment[0].compartment } : {},
    var.enable_tf_state_backup == true ? { "backup" : module.backup_compartment[0].compartment } : {},
    var.enable_shared_tools == true ? { "shared_tools" : module.shared_tools_compartment[0].compartment } : {},
    var.enable_dmz == true ? { "dmz" : module.dmz_compartment[0].compartment } : {},
  )
}

output "compartments" {
  value = local.compartments_map
}
