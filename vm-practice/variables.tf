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
variable "nsg_rules" {
  type = map(object({
    name      = string
    priority  = number
    direction = string
    access    = string
    protocol  = string
    port      = string
  }))
}
variable "alert_email" {
  type = string
}
