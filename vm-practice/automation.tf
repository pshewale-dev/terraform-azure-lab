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
    [bool]$StopVM = $true
)

try {
    Write-Output "Connecting using Managed Identity..."
    Connect-AzAccount -Identity | Out-Null

    Write-Output "Connected successfully."
    Write-Output "Resource Group: $ResourceGroupName"
    Write-Output "AutoShutdown tag: Yes"
    Write-Output "StopVM: $StopVM"

    $vms = Get-AzVM -ResourceGroupName $ResourceGroupName

    if (-not $vms) {
        Write-Output "No VMs found in Resource Group."
        return
    }

    $targetVMs = $vms | Where-Object {
        $_.Tags.ContainsKey("AutoShutdown") -and
        $_.Tags["AutoShutdown"] -eq "Yes"
    }

    if (-not $targetVMs) {
        Write-Output "No VMs found with AutoShutdown=Yes."
        return
    }

    foreach ($vm in $targetVMs) {

        Write-Output "----------------------------------------"
        Write-Output "Processing VM: $($vm.Name)"

        $vmStatus = Get-AzVM `
            -ResourceGroupName $ResourceGroupName `
            -Name $vm.Name `
            -Status

        $powerState = (
            $vmStatus.Statuses |
            Where-Object { $_.Code -like "PowerState/*" }
        ).DisplayStatus

        Write-Output "VM Name: $($vm.Name)"
        Write-Output "Current State: $powerState"

        if ($StopVM) {

            if ($powerState -eq "VM running") {

                Write-Output "Stopping VM: $($vm.Name)"

                Stop-AzVM `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $vm.Name `
                    -Force

                Write-Output "Stop operation completed for $($vm.Name)"
            }
            else {

                Write-Output "VM is not running."
                Write-Output "No action required."
            }
        }
        else {

            Write-Output "Status check only. No VM action taken."
        }
    }
}
catch {
    Write-Error $_.Exception.Message
    throw
}
CONTENT
}

resource "azurerm_role_assignment" "automation_vm_operator" {
  scope                = azurerm_linux_virtual_machine.lvm.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.automation.identity[0].principal_id
}

resource "azurerm_automation_schedule" "vm_shutdown" {
  name                    = "schedule-vm-shutdown"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Asia/Kolkata"
  start_time              = "2026-10-07T22:00:00+05:30"
  description             = "Daily VM shutdown schedule"
}

resource "azurerm_automation_job_schedule" "vm_shutdown" {
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation.name
  schedule_name           = azurerm_automation_schedule.vm_shutdown.name
  runbook_name            = azurerm_automation_runbook.vm_inventory.name

  parameters = {
    resourcegroup = "rg-practice-lab"
    stopvm        = "true"
  }
}
