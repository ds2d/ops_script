#!/bin/bash
#zabbix_agentd install
#2016-07-14
Zabbix_server="192.168.0.248"
groupadd zabbix
useradd -s /sbin/nologin -g zabbix zabbix
cd /etc/yum.repos.d/
rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum install zabbix-agent  zabbix-sender zabbix-get -y
sed -i "/^Server=$Zabbix_server/d" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Server=.*/Server=$Zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/^ServerActive=$Zabbix_server/d" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive=.*/ServerActive=$Zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
chkconfig zabbix-agent on
/etc/init.d/zabbix-agent restart

