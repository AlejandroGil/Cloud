Add-AzureRmAccount

$location = "westeurope"
$rgname = "xxx"
$vmConfigName = "xxx"
$vmssname = "xxx"

Set-AzureRmContext -SubscriptionName "xxx"

###################################
##  Create snapshot from Osdisk  ##
###################################
$vm = Get-AzureRmVm `
  -ResourceGroupName $rgname `
  -Name $vmConfigName

$snapshot = New-AzureRmSnapshotConfig `
  -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
  -Location $location `
  -CreateOption copy

$date = get-Date -UFormat "%d-%mh-%Hh"
$snapshotName = $vmConfigName + "-" + $date + "-snap"
New-AzureRmSnapshot `
   -Snapshot $snapshot `
   -SnapshotName $snapshotName `
   -ResourceGroupName $rgname

#################################
##  Create image from snapshot ##
#################################
$imageName = $vmConfigName + "-" + $date + "-image"
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