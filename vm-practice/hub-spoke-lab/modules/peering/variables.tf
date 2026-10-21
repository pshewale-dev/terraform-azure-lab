variable "name" {
  description = "VNet peering name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the source VNet"
  type        = string
}

variable "virtual_network_name" {
  description = "Source VNet name"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "Resource ID of the remote VNet"
  type        = string
}