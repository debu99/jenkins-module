AWS CI/CD Terraform module
========================

Terraform module which creates a jenkins host that allows SSH/Web login.

# Usage

```hcl
module "host" {
  source = "git::https://github.com/debu99/jenkins-module"

  aws_region        = "eu-west-1"
  environment_name  = "CompanyA"
  stage_name        = "Production"
  host_name         = "TestHost"
  vpc_id            = "vpc-72f02404"
  subnet_id         = "subnet-a694a3fd"
  availability_zone = "eu-west-1a"
  instance_type     = "t2.small"
  access_ips        = ["0.0.0.0/0"]
  public_keypair    = "ssh-rsa AAAAB...."
}
```

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS Region to run in. | string | - | yes |
| aws_profile | AWS Profile to use when working with this module. | string | `` | no |
| environment_name | The name of the environment we want to create. For example, 'DigiFarming'. | string | - | yes |
| stage_name | The name of the stage we're creating. For example, 'Sandbox' or 'Production'. | string | - | yes |
| host_name | Host name. (default: jenkins) | string | `jenkins` | no |
| create_instance | Whether to create the ec2 instance. (default = 1) | string | `1` | no |
| vpc_id | The VPC ID where the host should reside in. | string | - | yes |
| subnet_id | Subnet ID where the host should reside in. | string | - | yes |
| availability_zone | Availability Zone ID where the host should reside in. | string | - | yes |
| public_keypair | The public part of the SSH key that will be used to log in to EC2 instances. | string | - | yes |
| instance_type | EC2 instance type. (default: t2.small) | string | `t2.small` | no |
| access_ips | List of IP addresses to allow access to the host. (default: 0.0.0.0/0) | list | `<list>` | no |

# Outputs

| Name | Description |
|------|-------------|
| host_ip | The Elastic IP address of the host. |
| host_secgroup_id | The ID of the security group the host resides in. |
| host_secgroup_name | The name of the security group the host resides in. |

# Version history

## v0.1

Initial module. 

# Terraform version

Terraform version 0.11 or newer is required for this module to work.

# Examples

* [Jenkins Example](examples/jenkins-example)

# Authors

Module managed by [Vincent Liu](vincentliu01234@gmail.com)

# Confidentiality

Information classification: **Internal**

Information owner: **Vincent Liu**
