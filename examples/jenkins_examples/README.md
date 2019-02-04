CI/CD Module Example
==========

Configuration in this directory creates a CI/CD host using the module, as well as the related code required for accessing the CI/CD host to work.

Usage
=====

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Afterwards, verify connectivity using the following steps:

* Save the output from private_key into temp.pem,
* Save the output from host_ip and use it in the below command:
* SSH into the host using the following command: *ssh -i temp.pem core@HOST_IP*
* Use browser to access HOST_IP 8080 port.
* Make sure you are able to connect to the host.

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.