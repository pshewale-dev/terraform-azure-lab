locals {
  common_tags = {
    Environment       = "Dev"
    PolicyManaged     = "Yes"
    workload          = "lab"
    patching_schedule = "Daily"
  }

  vnet_address_space      = ["10.20.0.0/16"]
  subnet_address_prefixes = ["10.20.1.0/24"]
}
