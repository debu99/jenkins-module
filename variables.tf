variable "aws_region" {
  description = "AWS Region to run in."
}

variable "aws_profile" {
  description = "AWS Profile to use when working with this module."
  default     = ""
}

variable "environment_name" {
  description = "The name of the environment we want to create. For example, 'DigitalFarming'."
}

variable "stage_name" {
  description = "The name of the stage we're creating. For example, 'Staging' or 'Production'."
}

variable "host_name" {
  description = "The name of the host we're creating. For example, 'Jenkins'."
  default     = "Jenkins"
}

variable "create_instance" {
  description = "Whether to create instance or not"
  default     = 1
}

variable "vpc_id" {
  description = "The VPC ID where the host should reside in."
}

variable "subnet_id" {
  description = "Subnet ID where the host should reside in."
}

variable "availability_zone" {
  description = "Availability zone where the host should reside in."
}

variable "public_keypair" {
  description = "The public key of the SSH key that will be used to log in to EC2 instances in this environment."
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t2.small"
}

variable "access_ips" {
  type        = "list"
  description = "List of IP addresses to allow access to the host."
  default     = ["0.0.0.0/0"]
}
