terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://${var.deploy_account}@${var.host_server}/system"
}

#create pool and network
module "common" {
  source = "./kvm-common"
}
