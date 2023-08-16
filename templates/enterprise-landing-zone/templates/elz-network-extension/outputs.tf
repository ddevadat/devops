output "rpc_id" {
  value = (var.enable_vpn_or_fastconnect == "FASTCONNECT" || var.enable_drg_rpc) ? oci_core_remote_peering_connection.remote_peering_connection[0].id : null
}

