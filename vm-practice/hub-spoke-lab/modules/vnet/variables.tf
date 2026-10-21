variable "name" {
  description = "Virtual network name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the VNet"
  type        = string
}

variable "address_space" {
  description = "VNet address spaces"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Subnet address prefixes"
  type        = list(string)

  validation {
    condition     = length(var.subnet_prefixes) > 0
    error_message = "At least one subnet prefix must be supplied."
  }
}

variable "subnet_names" {
  description = "Subnet names"
  type        = list(string)

  validation {
    condition     = length(var.subnet_names) == length(var.subnet_prefixes)
    error_message = "Each subnet prefix must have a corresponding subnet name."
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
