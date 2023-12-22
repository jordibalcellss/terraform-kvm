terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

resource "libvirt_volume" "volume" {
  name = "${var.hostname}.qcow2"
  pool = "disks"
  base_volume_name = "base.qcow2"
  size = var.size
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "${var.hostname}-commoninit.iso"
  pool = "disks"
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.hostname
    deploy_account = var.deploy_account
    deploy_account_pwd = var.deploy_account_pwd
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_${var.method}.cfg")
  vars = {
    address = var.address
    gateway = var.gateway
    dns_1 = var.dns_1
    dns_2 = var.dns_2
    domain = var.domain
  }
}

resource "libvirt_domain" "domain" {
  name = var.hostname
  memory = var.memory
  vcpu = var.vcpu
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  autostart = true

  disk {
    volume_id = libvirt_volume.volume.id
  }
  
  network_interface {
    network_name = "network"
  }

  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}
