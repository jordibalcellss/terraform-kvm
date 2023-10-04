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
  path = "/mnt/kvm/disks"
}

resource "libvirt_network" "network" {
  name = "network"
  mode = "bridge"
  bridge = "br0"
  autostart = "true"
}
