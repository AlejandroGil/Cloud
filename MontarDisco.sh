#!/bin/bash
DIRECTORY=datadrive
(
echo n
echo  
echo  
echo  
echo  
echo w
) | sudo fdisk /dev/sdc
sudo mkfs -t ext4 /dev/sdc1
if [ ! -d $DIRECTORY ]; then
sudo mkdir /$DIRECTORY
sudo mount /dev/sdc1 /datadrive
UUID=`sudo -i blkid | grep sdc1 | awk -F'"' '{print $2}'`
fstab="UUID=$UUID /datadrive ext4 defaults 1 2"
sudo echo  $fstab >> /etc/fstab
sudo chmod go+w /datadrive
