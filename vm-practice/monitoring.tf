resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_monitor_data_collection_rule" "linux_syslog" {
  name                = "dcr-linux-syslog"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

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
  count                      = 2
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.lvm[count.index].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  tags                       = local.common_tags
}

resource "azurerm_monitor_data_collection_rule_association" "linux_syslog" {
  count                   = 2
  name                    = "dcr-association"
  target_resource_id      = azurerm_linux_virtual_machine.lvm[count.index].id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_syslog.id
}

resource "azurerm_monitor_action_group" "vm_alerts" {
  name                = "vm-practice-lab-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "VMAlerts"
  tags                = local.common_tags

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "vm_cpu" {
  name                = "alert-vm-cpu-high"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = azurerm_linux_virtual_machine.lvm[*].id
  description         = "Alert when VM CPU is above 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  tags                = local.common_tags
  target_resource_type     = "Microsoft.Compute/virtualMachines"
target_resource_location = azurerm_resource_group.rg.location

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
