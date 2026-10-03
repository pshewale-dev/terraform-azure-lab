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
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.20.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "snet-practice-lab"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"

    }
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_asso" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_network_interface" "nic" {
  name                = "nic-practice-lab"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "lvm" {
  name                  = "vm-practice-lab-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B2ats_v2"
  boot_diagnostics {}
  custom_data = filebase64("cloud-init.yaml")
  identity {
    type = "SystemAssigned"
  }

  admin_username = "azureadmin"
  admin_ssh_key {
    username   = var.admin_user
    public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
  }
  os_disk {
    name                 = "vm-practice-lab-01-os-disk"
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
resource "azurerm_virtual_machine_extension" "nginx" {
  name                 = "nginx_install"
  virtual_machine_id   = azurerm_linux_virtual_machine.lvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  settings             = <<SETTINGS
  {
    "commandToExecute": "sudo apt update && sudo apt install nginx -y"
  }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "machine_configuration" {
  name                       = "AzurePolicyforLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.lvm.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-practice-lab"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
}
resource "azurerm_role_assignment" "rbac" {
  principal_id         = azurerm_linux_virtual_machine.lvm.identity[0].principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
}
#resource "azurerm_key_vault_secret" "lab_secret" {
#  name         = "lab-secret"
#  value        = "temporary-placeholder"
#  key_vault_id = azurerm_key_vault.kv.id
#}