Add-AzureRmAccount

$SubscriptionName = ( Get-AzureRmSubscription | Out-GridView -Title "Select an Azure Subscription ..." -PassThru).Name
Set-AzureRmContext -SubscriptionName $SubscriptionName

$rgName = (Get-AzureRmResourceGroup | Out-GridView -Title "Select an Azure Resource Group ..." -PassThru).ResourceGroupName
$vmName = (Get-AzureRmVm -ResourceGroupName $rgName | Out-GridView -Title "Select an Azure Resource Group ..." -PassThru).Name

$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
$vm.StorageProfile.ImageReference