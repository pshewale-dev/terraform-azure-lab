locals {
  common_tags = {
    environment       = "practice"
    workload          = "lab"
    patching_schedule = "Daily"
    AutoShutdown      = "Yes"
  }

  vnet_address_space      = ["10.20.0.0/16"]
  subnet_address_prefixes = ["10.20.1.0/24"]
}
