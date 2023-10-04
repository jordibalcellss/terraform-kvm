#dhcp assigned instance
module "guest01" {
  source = "./kvm"
  depends_on = [module.common]
  hostname = "guest01"
}
