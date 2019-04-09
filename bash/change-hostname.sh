#!/bin/bash
# This is a shell script to change hostname
# version 0.1
# Created in 2015.8.11
# Creator Edison
ips=$(awk '{print $1}' /root/host)
#hosts=$(awk '{print $2}' /root/host)

for ip in $ips
do
#echo $ip
host=`grep $ip eng-host|awk '{print $2}'`
#echo $host
ssh -p2022 root@$ip "sed -i 's/^HOSTNAME.*/HOSTNAME=$host/' /etc/sysconfig/network"

ssh -p2022 root@$ip "sed -i 's/$ip.*/$ip $host/' /etc/hosts"
done
