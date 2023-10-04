# terraform-kvm

A Terraform module for [Kernel Virtual Machines](https://www.linux-kvm.org/)
(KVM/[libvirt](https://libvirt.org/)) utilizing
[terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt/).

## Description

The module allows creating and provisioning virtual machine fleets using
different mechanisms after implementing a manageable underlying infrastructure.

It is composed of two modules actually:

* `kvm-common`: creates a storage pool and defines a network. The module call
was appended to `provider.tf` for the sake of simplicity.
* `kvm`: runs per VM (or VM group) and adds volumes, prepares the cloud-init
image/s, renders the required templates and creates the domain/s.

## Requirements

### A host server

A preconfigured host server prepared for libvirt. During development I put
together an Ansible playbook available from
[ansible-host-server](https://github.com/jordibalcellss/ansible-host-server/)
and tested under CentOS 7.

### Terraform

[Terraform](https://www.terraform.io/) manual installation is quite
straightforward

```
wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
```

## Configuration

`main.tf` holds the specification for our deployment. The files under
`examples/` can be renamed and used to that purpose straight away.

### Input variables

| Name | Type | Description | Default |
| - | - | - | - |
| hostname | `string` | | `guest` |
| domain | `string` | Search domain | `local` |
| memory | `number` | Memory in megabytes | `512` |
| vcpu | `number` | Number of virtual cores | `1` |
| method | `string` | Address assign method, eiher `static` or `dhcp` | `dhcp` |
| address | `string` | IP address in CIDR notation | `""` |
| gateway | `string` | Default gateway | `""` |
| dns_1 | `string` | Primary nameserver | `""` |
| dns_2 | `string` | Secondary nameserver | `""` |
| deploy_account | `string` | Deployment account username | `deploy` |
| deploy_account_pwd | `string` | Deployment account password | `""` |
| host_server | `string` | Host server IP address | `""` |

### Implementing

The infrastructure can be planned, applied and destroyed by means of

```
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

During creation Terraform will use `cloud-init` to create a privileged
deployment account inside the VMs and provide the SSH key found in
`keys/id_rsa.pub`, so as to prepare the guest systems to be accessed by
further provisioning systems.

## Examples

### Single statically addressed VM

```hcl
module "guest01" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest01"
  method = "static"
  address = "10.12.0.111/24"
  gateway = "10.12.0.1"
}
```

### Multiple VMs with random hostnames

```hcl
variable "instances" { default = 3 }

resource "random_string" "hostname" {
  length = 4
  special = false
  upper = false
  count = "${var.instances}"
}

module "guests" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "${random_string.hostname[count.index].result}"
  count = "${var.instances}"
}
```

Which created three VMs

```
[root@host deploy]# virsh list
 Id    Name                           State
----------------------------------------------------
 1     adym                           running
 2     yw6q                           running
 3     e4r3                           running
```

Alongside their volumes

```
[root@host deploy]# ls -lh /mnt/kvm/disks/
total 2.7G
-rw-r--r--. 1 qemu qemu 366K Oct  4 00:41 adym-commoninit.iso
-rw-r--r--. 1 qemu qemu 898M Oct  4 00:42 adym.qcow2
-rw-r--r--. 1 qemu qemu 366K Oct  4 00:41 e4r3-commoninit.iso
-rw-r--r--. 1 qemu qemu 897M Oct  4 00:42 e4r3.qcow2
-rw-r--r--. 1 qemu qemu 366K Oct  4 00:41 yw6q-commoninit.iso
-rw-r--r--. 1 qemu qemu 899M Oct  4 00:42 yw6q.qcow2
```

Please, browse the `examples/` folder for further scripts.

## References

* [dmacvicar/libvirt (Terraform Registry)](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/)
* [cloud-init](https://cloudinit.readthedocs.io/en/latest/reference/)
* [fabianlee/terraform-libvirt-ubuntu-examples](https://github.com/fabianlee/terraform-libvirt-ubuntu-examples/)
* [MonolithProjects/terraform-libvirt-vm](https://github.com/MonolithProjects/terraform-libvirt-vm/)
