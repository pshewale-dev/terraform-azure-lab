output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = module.hub.vnet_id
}

output "spoke1_vnet_id" {
  description = "ID of spoke 1 virtual network"
  value       = module.spoke1.vnet_id
}

output "spoke2_vnet_id" {
  description = "ID of spoke 2 virtual network"
  value       = module.spoke2.vnet_id
}