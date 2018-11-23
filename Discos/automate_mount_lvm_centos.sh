#!/bin/bash
#get device to mount
physical_device=$(sudo grep SCSI /var/log/messages | tail -1 | grep -i attached | awk '{print $8}' | tr -d [])

#install lv2 in case it is not installed
sudo yum install -y lvm2

#create volumegroup and logicalvolume
sudo vgcreate vg1 /dev/"$physical_device"
sudo lvcreate -l 100%FREE -n lv1 vg1
sudo mkfs.ext4 /dev/vg1/lv1
sudo mkdir /datadrive
sudo mount /dev/mapper/vg1-lv1 /datadrive/
fstab="/dev/mapper/vg1-lv1 /datadrive ext4 defaults 0 0"
echo "$fstab" | sudo tee --append /etc/fstab
