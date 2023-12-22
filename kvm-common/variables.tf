variable "pool_path" {
  default = "/mnt/kvm/disks"
  type = string
  description = "Virtual disks path"
}

variable "image" {
  default = "http://mirror.netzwerge.de/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.3-20231113.x86_64.qcow2"
  type = string
  description = "Source qcow2 base image URL"
}
