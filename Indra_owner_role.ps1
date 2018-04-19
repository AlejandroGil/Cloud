$role = $null
$role = Get-AzureRmRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = "Indra owner"
$role.Description = "Lets you view everything and operate VMs."

$role.Actions.Clear()
$role.Actions.Add("*/read")
$role.Actions.Add("*/virtualMachines/start/action")
$role.Actions.Add("*/virtualMachines/powerOff/action")
$role.Actions.Add("*/virtualMachines/restart/action")
$role.Actions.Add("*/virtualMachines/stop/action")
$role.Actions.Add("*/virtualMachines/shutdown/action")
$role.Actions.Add("*/virtualMachines/deallocate/action")
$role.Actions.Add("*/virtualMachines/generalize/action")
$role.Actions.Add("*/virtualMachines/capture/action")
$role.Actions.Add("*/virtualMachines/performMaintenance/action")
$role.Actions.Add("Microsoft.Network/networkSecurityGroups/securityRules/write")
$role.Actions.Add("Microsoft.Network/networkSecurityGroups/write")
$role.Actions.Add("Microsoft.Network/networkSecurityGroups/securityRules/delete")
$role.NotActions.Add("Microsoft.Billing/billingPeriods/read")
$role.NotActions.Add("Microsoft.Billing/invoices/read")

$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("xxx")

New-AzureRmRoleDefinition -Role $role