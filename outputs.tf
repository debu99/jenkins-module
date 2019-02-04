output "host_ip" {
  description = "The Elastic IP address of the Host."
  value       = "${element(concat(aws_eip.host_eip.*.public_ip, list("")), 0)}"
}

output "host_secgroup_id" {
  description = "The ID of the security group the host resides in."
  value       = "${aws_security_group.host_security_group.id}"
}

output "host_secgroup_name" {
  description = "The name of the security group the host resides in."
  value       = "${aws_security_group.host_security_group.name}"
}
