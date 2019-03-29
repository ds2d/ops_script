#!/bin/bash
# ssh 免密登录，批量传送公钥
#set timeout 10

password="123456"

for ip in `cat newip`
do
echo "copy pubkey to $ip"
/usr/bin/expect << EOF
spawn ssh-copy-id -i  /root/.ssh/id_rsa.pub root@$ip
expect {
    "yes/no" { send "yes\r";exp_continue }
    "*password:" {send "$password\r";exp_continue}
    }
expect eof
EOF
done
