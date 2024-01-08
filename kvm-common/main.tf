terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

resource "libvirt_pool" "disks" {
  name = "disks"
  type = "dir"
  path = var.pool_path
}

resource "libvirt_volume" "base_volume" {
  name = "base.qcow2"
  pool = "disks"
  source = var.image
  format = "qcow2"
}
