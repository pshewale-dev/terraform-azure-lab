############ Main.tf ############
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttflabstate2026"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
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

resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-tf-lab-dev"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.10.0.0/16"]
}
resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.10.1.0/24"]
}
resource "azurerm_network_security_group" "web" {
  name                = "nsg-tf-lab-web"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}
resource "azurerm_network_interface" "web" {
  name                = "nic-tf-lab-web"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "web" {
  name                = "tf-lab-vm-web1"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_D2a_v4"
  identity {
    type = "SystemAssigned"
  }
  network_interface_ids = [azurerm_network_interface.web.id]
  admin_username        = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

