#statically assigned instance
module "guest01" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest01"
  method = "static"
  address = "10.12.0.111/24"
  gateway = "10.12.0.1"
}

#dhcp assigned instance
module "guest02" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest02"
  memory = 1024
  vcpu = 2
}
