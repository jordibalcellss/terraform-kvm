#using for_each
module "guests" {
  source = "./kvm"
  depends_on = [module.common]
  for_each = toset(["guest01", "guest02"])
  hostname = each.value
}
