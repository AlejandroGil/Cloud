Add-AzureRmAccount
Set-AzureRmContext -SubscriptionName "xxx"
$vmName = "xxx"
$rg = "xxx"
$diskName = "xxx"

# Get the VM
$vm = Get-AzureRmVM -ResourceGroupName $rg -Name $vmName

# Make sure the VM is stopped\deallocated
#Stop-AzureRmVM -ResourceGroupName $rg -Name $vm.Name -Force

# Get the new disk that you want to swap in
$disk = Get-AzureRmDisk -ResourceGroupName $rg -Name $diskName

# Set the VM configuration to point to the new disk
Set-AzureRmVMOSDisk -VM $vm -ManagedDiskId $disk.Id -Name $disk.Name 

# Update the VM with the new OS disk
Update-AzureRmVM -ResourceGroupName $rg -VM $vm 

# Start the VM
Start-AzureRmVM -Name $vm.Name -ResourceGroupName $rg