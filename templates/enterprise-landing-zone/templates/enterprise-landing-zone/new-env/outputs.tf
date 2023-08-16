
output "newenv_environment" {
  value = {
    environment_prefix   = var.newenv_environment_prefix
    compartments         = module.newenv_environment.compartment
    hub_network          = module.newenv_environment.hub_network
    drg_id               = module.newenv_environment.drg_id
    identity_domain      = module.newenv_environment.identity_domain
    default_log_group_id = module.newenv_environment.default_log_group_id
    shared_tools_network = module.newenv_environment.shared_tools_network
  }
}

output "dynamic_group_detail_newenv" {
  value = module.osms_dynamic_group_newenv
}
