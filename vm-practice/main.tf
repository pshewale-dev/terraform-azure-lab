## Practice VM Main.tf ##
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
  custom_data                                            = filebase64("cloud-init.yaml")
  patch_mode                                             = "AutomaticByPlatform"
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  identity {
    type = "SystemAssigned"
  }

  tags = {
    patching_schedule = "Daily"
    AutoShutdown      = "Yes"
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
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_monitor_data_collection_rule" "linux_syslog" {
  name                = "dcr-linux-syslog"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  destinations {
    log_analytics {
      name                  = "law-destination"
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["law-destination"]
  }

  data_sources {
    syslog {
      name           = "linux-syslog"
      facility_names = ["auth", "authpriv", "cron", "daemon", "syslog", "user"]
      log_levels     = ["Error", "Warning", "Info"]
      streams        = ["Microsoft-Syslog"]
    }
  }
}
resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.lvm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
}
resource "azurerm_monitor_data_collection_rule_association" "linux_syslog" {
  name                    = "dcr-association"
  target_resource_id      = azurerm_linux_virtual_machine.lvm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_syslog.id
}
resource "azurerm_monitor_action_group" "vm_alerts" {
  name                = "vm-practice-lab-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "VMAlerts"
  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}
resource "azurerm_monitor_metric_alert" "vm_cpu" {
  name                = "alert-vm-cpu-high"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.lvm.id]

  description = "Alert when VM CPU is above 80%"

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.vm_alerts.id
  }
}
resource "azurerm_maintenance_configuration" "patching" {
  name                     = "mc-linux-patching"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = "User"
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
#resource "azurerm_maintenance_assignment_virtual_machine" "patching" {
#  location                     = azurerm_resource_group.rg.location
#  maintenance_configuration_id = azurerm_maintenance_configuration.patching.id
#  virtual_machine_id           = azurerm_linux_virtual_machine.lvm.id
#}
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
resource "azurerm_automation_account" "automation" {
  name                = var.automation_account
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_role_assignment" "automation_reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_automation_account.automation.identity[0].principal_id
}
resource "azurerm_automation_runbook" "vm_inventory" {
  name                    = "runbook-practice-lab"
  location                = "southeastasia"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = <<CONTENT
param (
    [string]$ResourceGroupName = "rg-practice-lab",
    [bool]$StopVM = $false
)

Connect-AzAccount -Identity

Write-Output "Resource Group: $ResourceGroupName"
Write-Output "AutoShutdown tag: Yes"
Write-Output "StopVM: $StopVM"

$vms = Get-AzVM `
    -ResourceGroupName $ResourceGroupName `
    -Status

$targetVMs = $vms | Where-Object {
    $_.Tags["AutoShutdown"] -eq "Yes"
}

if ($targetVMs.Count -eq 0) {
    Write-Output "No VMs found with AutoShutdown=Yes."
    exit
}

foreach ($vm in $targetVMs) {

    $powerState = ($vm.Statuses |
        Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus

    Write-Output "VM Name: $($vm.Name)"
    Write-Output "Current State: $powerState"

    if ($StopVM) {

        if ($powerState -eq "VM running") {

            Write-Output "Stopping VM: $($vm.Name)"

            Stop-AzVM `
                -ResourceGroupName $ResourceGroupName `
                -Name $vm.Name `
                -Force

            Write-Output "Stop operation completed for $($vm.Name)."
        }
        else {
            Write-Output "$($vm.Name) is not running. No action required."
        }
    }
    else {
        Write-Output "Status check only. No VM action taken."
    }
}
CONTENT
}
resource "azurerm_role_assignment" "automation_vm_operator" {
  scope                = azurerm_linux_virtual_machine.lvm.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.automation.identity[0].principal_id
}