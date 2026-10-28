variable "resource_group_name" {
  description = "Resource group name for the Hub-Spoke lab"
  type        = string
  default     = "rg-hub-spoke-lab"
}

variable "location" {
  description = "Azure region for the lab"
  type        = string
  default     = "Central India"
}

variable "tags" {
  description = "Tags applied to lab resources"
  type        = map(string)
  default = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "hub-spoke"
  }
}