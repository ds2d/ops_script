#!/bin/bash
# create lvm disk
# @date: 2018-11-30

disk_name=$1
pvcreate /dev/$disk_name
vgcreate vgname /dev/$disk_name
lvcreate -L 50G -n lvname vgname
mkfs.ext4  /dev/vgname/lvname

mkdir -p /data

mount /dev/vgname/lvname /data

echo "/dev/vgname/lvname      /data       ext4    defaults        0 0" >> /etc/fstab

