#!/bin/bash

print_help() {
  echo "Usage arguments:"
  echo
  echo "-u | --user"
  echo "-p | --password"
  echo "-t | --tenant"
  echo "-rg | --resourceGroup"
  echo "-vm | --vmConfigName"
  echo "-vmss"
  echo
}

if [ $# -lt 9 ]
  then
    echo "Inssuficient arguments"
    exit
fi

while [ -n "${1}" ]
do
    case "${1}" in
    -u | --user)
        SP_USER=${2}
        shift 2
    ;;
    -p | --password)
        SP_PASS=${2}
        shift 2
    ;;
    -t | --tenant)
        TENANT=${2}
        shift 2
    ;;
    -rg | --resourceGroup)
        RG_NAME=${2}
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

az login --service-principal -u $SP_USER -p $SP_PASS -t $TENANT
SUBSCRIPTION="Intelligent Valuations"
az account set -s $SUBSCRIPTION

location="westeurope"
DATE=$(date +"%Y-%m-%d_%H%M%S" -d "+1 hour")
SNAPSHOT_NAME=$VM_CONFIG_NAME-$DATE-"snap"
IMAGE_NAME=$VM_CONFIG_NAME-$DATE-"image"

DISK_NAME=$(az vm get-instance-view -n $VM_CONFIG_NAME -g $RG_NAME --query storageProfile.osDisk.managedDisk.id | tr -d '"')

#Create snapshot from VM
az snapshot create -g $RG_NAME -n $SNAPSHOT_NAME --source $DISK_NAME
#Create image from snapshot -u 
az image create -g $RG_NAME -n $IMAGE_NAME --os-type Linux --source $SNAPSHOT_NAME
imageId=$(az image show -n $IMAGE_NAME -g $RG_NAME --query id)
#Update VMSS with the image
az vmss update --name $VMSS_NAME --resource-group $RG_NAME --set virtualMachineProfile.storageProfile.imageReference.id=$imageId