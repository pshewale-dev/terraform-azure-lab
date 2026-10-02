## Parctic VM Main.tf ##
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  #name     = var.resource_group_name
  for_each = var.vm_sizes
  name = "rg-parctice-${each.key}"
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-parctice-lab"
  for_each = var.vm_sizes
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  address_space       = ["10.20.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "snet-practice-lab"
  for_each = var.vm_sizes
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.20.1.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-parctice-lab"
  for_each = var.vm_sizes
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
}
resource "azurerm_network_security_rule" "rules" {
  for_each = var.vm_sizes
  name                        = "allow_ssh"
  priority                    = "100"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg[each.key].name
  network_security_group_name = azurerm_network_security_group.nsg[each.key].name
}
resource "azurerm_subnet_network_security_group_association" "nsg_asso" {
 for_each = var.vm_sizes
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
resource "azurerm_network_interface" "nic" {
  #count               = 3
  #name                = "nic-parctice-lab-${count.index + 1}"
  for_each            = var.vm_sizes
  name                = "nic-parctice-lab-${each.key}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "lvm" {
  #count                 = 3
  #name                  = "vm-parctice-lab-${count.index + 1}"
  for_each              = var.vm_sizes
  name                  = "vm-parctice-lab-${each.key}"
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  location              = azurerm_resource_group.rg[each.key].location
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  #size                  = "Standard_B2ats_v2"
  size = each.value
  identity {
    type = "SystemAssigned"
  }

  admin_username = "azureadmin"
  admin_ssh_key {
    username   = var.admin_user
    public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

