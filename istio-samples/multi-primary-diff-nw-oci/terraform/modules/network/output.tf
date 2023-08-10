output "vcn_id" {
  description = "id of vcn that is created"
  value       = oci_core_virtual_network.vcn.id
}

output "subnet_k8s_ep_id" {
  description = "subnet id of k8s endpoint "
  value       = oci_core_subnet.k8s_api_ep_subnet.id
}

output "subnet_lb_id" {
  description = "subnet id of lb"
  value       = oci_core_subnet.lb_subnet.id
}

output "subnet_worker_id" {
  description = "subnet id of worker node"
  value       = oci_core_subnet.worker_subnet.id
}