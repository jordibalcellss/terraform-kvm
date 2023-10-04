#statically assigned instances
module "guest01" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest01"
  method = "static"
  address = "10.12.0.111/24"
  gateway = "10.12.0.1"
}

module "guest02" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest02"
  method = "static"
  address = "10.12.0.112/24"
  gateway = "10.12.0.1"
}
