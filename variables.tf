variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "ssh_public_key" {
  description = "SSH public key used to access Linux VMs"
  type        = string
}
