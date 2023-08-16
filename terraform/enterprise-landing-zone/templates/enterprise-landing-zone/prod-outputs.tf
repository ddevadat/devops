
output "prod_environment" {
  value = {
    environment_prefix   = var.prod_environment_prefix
    compartments         = module.prod_environment.compartment
    hub_network          = module.prod_environment.hub_network
    drg_id               = module.prod_environment.drg_id
    identity_domain      = module.prod_environment.identity_domain
    default_log_group_id = module.prod_environment.default_log_group_id
    shared_tools_network = module.prod_environment.shared_tools_network
  }
}

output "dynamic_group_detail_prod" {
  value = module.osms_dynamic_group_prod
}
