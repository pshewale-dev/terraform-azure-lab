resource "azurerm_linux_virtual_machine" "lvm" {
  name                  = "vm-practice-lab-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_sizes["web"]
  boot_diagnostics {}
  custom_data                                            = filebase64("cloud-init.yaml")
  patch_mode                                             = "AutomaticByPlatform"
  bypass_platform_safety_checks_on_user_schedule_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = merge(local.common_tags, {
    AutoShutdown = "Yes"
  })

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
  tags                 = local.common_tags
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
  tags                       = local.common_tags
}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-practice-lab"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = local.common_tags
}

resource "azurerm_role_assignment" "rbac" {
  principal_id         = azurerm_linux_virtual_machine.lvm.identity[0].principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
}

resource "azurerm_maintenance_configuration" "patching" {
  name                     = "mc-linux-patching"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = "User"
  tags                     = local.common_tags

  window {
    start_date_time = "2026-10-04 15:30"
    duration        = "03:00"
    time_zone       = "India Standard Time"
    recur_every     = "1Day"
  }

  install_patches {
    reboot = "Always"

    linux {
      classifications_to_include = [
        "Critical",
        "Security",
        "Other"
      ]
    }
  }
}

resource "azurerm_maintenance_assignment_dynamic_scope" "daily" {
  name                         = "daily-patching-scope"
  maintenance_configuration_id = azurerm_maintenance_configuration.patching.id

  filter {
    tag_filter = "Any"

    tags {
      tag    = "patching_schedule"
      values = ["Daily"]
    }
  }
}
