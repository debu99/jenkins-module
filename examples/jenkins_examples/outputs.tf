output "host_ip" {
  value = "${module.host.host_ip}"
}

output "private_key" {
  value = "${tls_private_key.ssh.private_key_pem}"
}
