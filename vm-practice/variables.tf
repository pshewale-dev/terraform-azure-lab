## Variables.tf ###
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "admin_user" {
  type = string
}
variable "vm_sizes" {
  type = map(string)
}
