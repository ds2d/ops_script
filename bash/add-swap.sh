#!/bin/bash
# 创建swap分区

# 确定swap文件的大小,单位为M.将该值乘以1024得到块大小.
dd if=/dev/zero of=/swapfile bs=1024 count=4096000

# 建立swap文件
mkswap /swapfile

# 立即打开swap文件而不是在启动时自动开启
swapon /swapfile

# 启动时开启,需要在/etc/fstab中添加如下内容
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
cat /proc/swaps

# 删除swap，删除 /etc/fstab
#swapoff /swapfile
#rm -rf /swapfile

