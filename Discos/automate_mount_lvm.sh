#!/bin/bash

physical_device=sudo grep SCSI /var/log/syslog | tail -1 | grep -i attached | awk '{print $10}' | tr -d []

sudo apt-get install -y lvm2
sudo vgcreate vg1 /dev/${physical_device}
sudo lvcreate -l 100%FREE -n lv1 vg1
sudo mkfs.ext4 /dev/vg1/lv1
sudo mkdir /datadrive
sudo mount /dev/mapper/vg1-lv1 /datadrive/
fstab="/dev/mapper/vg1-lv1 /datadrive ext4 defaults 0 0"
echo $fstab | sudo tee --append /etc/fstab