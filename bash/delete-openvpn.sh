#!/bin/bash
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
# date 2018.07.16
# OpenVPN 2.4.5
# openvpn 吊销客户端证书
# auth: liubb

set -x
user=$1

if [ $# -ne 1 ];then
    echo "Usage  $0 vpnuser  # vpnuser为需要删除的用户名"
    exit 10
fi

cd /etc/openvpn/easy-rsa/3.0.3
source vars
./easyrsa revoke $user
./easyrsa gen-crl
\cp pki/crl.pem  /etc/openvpn/

cd /etc/openvpn/easy-rsa/3.0.3
rm -f pki/private/$user.key
rm -f pki/issued/$user.crt
rm -f pki/reqs/$user.req

# delete user zip
rm -f /root/install/zip-client/$user.zip

cd /etc/openvpn/client-cert
rm -rf $user
rm -f $user.zip

/etc/init.d/openvpn restart


