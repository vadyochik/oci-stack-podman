output "ssh_private_key" {
  value     = tls_private_key.compute_ssh_key.*.private_key_pem
  sensitive = true
}

output "instances_public_ips" {
  value = {
    for k, v in oci_core_instance.instance : v.display_name => v.public_ip
  }
}
