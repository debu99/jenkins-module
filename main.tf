provider "aws" {
  version = "~> 1.0"
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

data "aws_partition" "current" {}

# Security Group
resource "aws_security_group" "host_security_group" {
  name   = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.access_ips}"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${var.access_ips}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)} SG"
    Environment = "${var.environment_name}"
    Stage       = "${var.stage_name}"
    Type        = "SecurityGroup"
  }
}

# Userdata for the host
data "template_file" "cicd_userdata" {
  template = "${file("${path.module}/userdata/userdata.yaml")}"
}

# Get Latest AMI
data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["595879546273"] # CoreOS

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Elastic IP for the host
resource "aws_eip" "host_eip" {
  count = "${var.create_instance}"
  vpc   = true

  tags {
    Name        = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)} EIP"
    Environment = "${var.environment_name}"
    Stage       = "${var.stage_name}"
    Type        = "ElasticIP"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = "${var.create_instance}"
  instance_id   = "${aws_instance.cicd_host.id}"
  allocation_id = "${aws_eip.host_eip.id}"
}

# Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.environment_name} ${var.stage_name} KeyPair"
  public_key = "${var.public_keypair}"
}

# CI/CD instance
resource "aws_instance" "cicd_host" {
  count                  = "${var.create_instance}"
  ami                    = "${data.aws_ami.coreos.id}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${aws_security_group.host_security_group.id}"]
  subnet_id              = "${var.subnet_id}"
  user_data              = "${data.template_file.cicd_userdata.rendered}"

  key_name = "${aws_key_pair.key_pair.key_name}"

  tags {
    Name        = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)}"
    Environment = "${var.environment_name}"
    Stage       = "${var.stage_name}"
    Type        = "Jenkins"
  }

  volume_tags {
    Name        = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)}"
    Environment = "${var.environment_name}"
    Stage       = "${var.stage_name}"
    Type        = "Volume"
  }
}

# volume for CI/CD
resource "aws_ebs_volume" "cicd_ebs" {
  availability_zone = "${var.availability_zone}"
  size              = "20"
  type              = "standard"

  tags {
    Name        = "${lower(var.stage_name)}-${lower(var.environment_name)}-${lower(var.host_name)} DataVol"
    Environment = "${var.environment_name}"
    Stage       = "${var.stage_name}"
    Type        = "Volume"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.cicd_ebs.id}"
  instance_id = "${aws_instance.cicd_host.id}"
}
