#!/bin/bash
DIRECTORY=datadrive
DEVICE=sdc
DEVICE1=sdc1
(
echo n
echo
echo
echo
echo
echo w
) | sudo fdisk /dev/$DEVICE
sudo mkfs -t ext4 /dev/$DEVICE1
if [ ! -d $DIRECTORY ]; then
  sudo mkdir /$DIRECTORY
fi
sudo mount /dev/$DEVICE1 /$DIRECTORY
UUID=`sudo -i blkid | grep $DEVICE1 | awk -F'"' '{print $2}'`
fstab="UUID=$UUID /datadrive ext4 defaults 1 2"
sudo echo  $fstab >> /etc/fstab
sudo chmod go+w /$DIRECTORY
