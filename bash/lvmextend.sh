#!/bin/bash
# lvextend 
# @date 2018-11-30
# 磁盘分区先化好

dev_name=$1
pvcreate /dev/$dev_name
vgextend vgwdzj /dev/$dev_name
lvextend -L +9G /dev/vgwdzj/lvwdzj
resize2fs /dev/vgwdzj/lvwdzj

