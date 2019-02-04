variable "region" {
  default = "ap-southeast-1"
}

variable "profile" {
  default = "infra-terragrunt"
}

provider "aws" {
  version = "~> 1.0"
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {}

data "aws_subnet" "selected" {
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

module "host" {
  source            = "git::https://github.com/debu99/jenkins-module?ref=0.1"
  #source            = "../../"
  create_instance   = 1
  environment_name  = "DigiFarming"
  host_name         = "Jenkins"
  stage_name        = "Staging"
  access_ips        = ["0.0.0.0/0", "1.2.3.4/32"]
  instance_type     = "t2.small"
  aws_region        = "${var.region}"
  aws_profile       = "${var.profile}"
  vpc_id            = "${data.aws_vpc.default.id}"
  subnet_id         = "${data.aws_subnet.selected.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  public_keypair    = "${tls_private_key.ssh.public_key_openssh}"
}
