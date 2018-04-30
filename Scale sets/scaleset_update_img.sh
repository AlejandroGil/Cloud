#!/bin/bash

az login --service-principal --username APP_ID --tenant TENANT_ID --password PATH_TO_CERT

location="westeurope"
rgName="xxx"
vmConfigName="xxx"
vmssName="xxx"
date=`date +"%d-%m-%Hh"`
snapName=$vmConfigName + $date + "-snap"
imageName=$vmConfigName + $date + "-image"
diskName=az vm get-instance-view -n $vmConfigName -g $rgname --query storageProfile.osDisk.name

#Create snapshot from VM
az snapshot create -g $rgName -n $snapName --source $diskName
#Create image from snapshot
az image create -g $rgName -n $imageName --os-type Linux --source $snapName
$imageId = az image show -n $imageName -g $rgName --query id
#Update VMSS with the image
az vmss update --name $vmssName --resource-group $rgName --set virtualMachineProfile.storageProfile.imageReference.id=$imageId
