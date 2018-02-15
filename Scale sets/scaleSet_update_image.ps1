$rgname = "xxx"
$vmssname = "xxx"
$newImageReference = "/subscriptions/xxx"

#Image from napshot params
$snapshotName = "config-snapshot-test"
$location = "westeurope"
$imageName = "config-image-test"

Set-AzureRmContext -SubscriptionName "xxx"

#################################
##  Create image from snapshot ##
#################################
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $rgName -SnapshotName $snapshotName
$imageConfig = New-AzureRmImageConfig -Location $location
$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType Linux -SnapshotId $snapshot.Id
$rmImage = New-AzureRmImage -ImageName $imageName -ResourceGroupName $rgName -Image $imageConfig

#################################
##       Update the vmss       ##
#################################
$vmss = Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssname
$vmss.virtualMachineProfile.storageProfile.imageReference.id = $rmImage.id
Update-AzureRmVmss -ResourceGroupName $rgname -Name $vmssname -VirtualMachineScaleSet $vmss
Update-AzureRmVmss -ResourceGroupName $rgname -VirtualMachineScaleSet $vmss
