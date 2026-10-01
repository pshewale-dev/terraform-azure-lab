
output "vm_id" {
  value = azurerm_linux_virtual_machine.web.id
}
output "vm_private_ip" {
  value = azurerm_network_interface.web.private_ip_address
}
