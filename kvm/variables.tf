variable "hostname" {
  default = "guest"
  type = string
  description = "Hostname"
}

variable "domain" {
  default = "local"
  type = string
  description = "Search domain"
}

variable "memory" {
  default = 512
  type = number
  description = "Memory in megabytes"
}

variable "vcpu" {
  default = 1
  type = number
  description = "Number of virtual cores"
}

variable "size" {
  default = 17179869184
  type = number
  description = "Virtual disk size in bytes (defaults to 16 GB)"
}

variable "method" {
  default = "dhcp"
  type = string
  description = "Address assign method, either static or dhcp"
}

variable "address" {
  default = ""
  type = string
  description = "IP address in CIDR notation"
}

variable "gateway" {
  default = ""
  type = string
  description = "Default gateway"
}

variable "dns_1" {
  default = ""
  type = string
  description = "Primary nameserver"
}

variable "dns_2" {
  default = ""
  type = string
  description = "Secondary nameserver"
}

variable "deploy_account" {
  default = "deploy"
  type = string
  description = "Deployment account username"
}

variable "deploy_account_pwd" {
  type = string
  description = "Deployment account password"
}
