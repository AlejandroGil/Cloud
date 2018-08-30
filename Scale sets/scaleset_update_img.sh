#!/bin/bash

print_help() {
  echo "Usage arguments:"
  echo
  echo "-rg | --resourceGroup"
  echo "-crg | --configResourceGroup"
  echo "-vm | --vmConfigName"
  echo "-vmss"
  echo
}

if [ $# -lt 7 ]
  then
    echo "Inssuficient arguments"
    exit
fi

while [ -n "${1}" ]
do
    case "${1}" in
    -rg | --resourceGroup)
        RG_NAME=${2}
        shift 2
    ;;
    -crg | --configResourceGroup)
        CONFIG_RG_NAME=${2}
        shift 2
    ;;
    -vm | --vmConfigName)
        VM_CONFIG_NAME=${2}
        shift 2
    ;;
    -vmss)
        VMSS_NAME=${2}
        shift 2
    ;;
    *)
        echo "Unexpected argument: ${1}. Exiting"
        print_help
        exit 1;
    ;;
    esac
done

location="westeurope"
DATE=$(date +"%Y-%m-%d_%H%M%S" -d "+2 hour")
SNAPSHOT_NAME=$VM_CONFIG_NAME-$DATE-"snap"
IMAGE_NAME=$VM_CONFIG_NAME-$DATE-"image"

DISK_NAME=$(az vm get-instance-view -n $VM_CONFIG_NAME -g $CONFIG_RG_NAME --query storageProfile.osDisk.managedDisk.id | tr -d '"')

#Create snapshot from VM
az snapshot create -g $RG_NAME -n $SNAPSHOT_NAME --source $DISK_NAME
#Create image from snapshot
az image create -g $RG_NAME -n $IMAGE_NAME --os-type Linux --source $SNAPSHOT_NAME
imageId=$(az image show -n $IMAGE_NAME -g $RG_NAME --query id)
#Update VMSS with the image
az vmss update --name $VMSS_NAME --resource-group $RG_NAME --set virtualMachineProfile.storageProfile.imageReference.id=$imageId