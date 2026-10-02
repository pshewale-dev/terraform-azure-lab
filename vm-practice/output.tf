output "vm_id" {
  value = azurerm_linux_virtual_machine.lvm.id
}
output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}
output "vm_extension_id" {
  value = azurerm_virtual_machine_extension.nginx.id
}

