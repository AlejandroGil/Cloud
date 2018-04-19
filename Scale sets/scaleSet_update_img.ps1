Add-AzureRmAccount

$rgname = "xxx"
$vmssname = "xxx"

#Image from napshot params
$snapshotName = "xxx"
$location = "westeurope"
$imageName = "xxx"

Set-AzureRmContext -SubscriptionName "xxx"

#################################
##  Create image from snapshot ##
#################################
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $rgName -SnapshotName $snapshotName
$imageConfig = New-AzureRmImageConfig -Location $location
$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType Linux -SnapshotId $snapshot.Id
$rmImage = New-AzureRmImage -ImageName $imageName -ResourceGroupName $rgName -Image $imageConfig

#En caso que la imagen exista:
#$rmImage = Get-AzureRmImage -ImageName $imageName -ResourceGroupName $rgname

#################################
##       Update the vmss       ##
#################################
$vmss = Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssname
$vmss.virtualMachineProfile.storageProfile.imageReference.id = $rmImage.id
Update-AzureRmVmss -ResourceGroupName $rgname -Name $vmssname -VirtualMachineScaleSet $vmss