Add-AzureRmAccount

$subscription = "Intelligent Valuations"
$rg = "AVM-v2"
$vmssName = "AVMv2-testigos-vmss"

Set-AzureRmContext -SubscriptionName $subscription
$vmss = Get-AzureRmVmss -ResourceGroupName $rg -VMScaleSetName $vmssName
Set-AzureRmVmssRollingUpgradePolicy -VirtualMachineScaleSet $vmss -MaxBatchInstancePercent 20 -MaxUnhealthyInstancePercent 20 -MaxUnhealthyUpgradedInstancePercent 5 -PauseTimeBetweenBatches "PT1M" | Update-AzureRmVmss
