#!/bin/bash
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
# date 2018.12.28
# OpenVPN 2.4.5
# openvpn 客户端证书生成 v2.0
# auth: liubb

User=$1
#Serverpass="123456"
Easyrsa_dir="/etc/openvpn/easy-rsa/3.0.3"
User_crt="${Easyrsa_dir}/pki/issued"
User_key="${Easyrsa_dir}/pki/private"
User_dir="/etc/openvpn/client-cert/"
Server_crt="${Easyrsa_dir}/pki"
Secret_key="${Easyrsa_dir}"

if [ $# -lt 1 ]
then
    echo "    Usage $0 vpnuser # user是你需要创建的vpn用户"
    exit 10
fi

cd $Easyrsa_dir
# start creat user crt
echo -e "\033[0;31mstart create $User The certificate file......\033[0m"

./easyrsa build-client-full $User nopass

sleep 3
echo -e  "\033[0;31mCertificate creation completed\033[0m"

# 使用spawn的交互方法自动输入用户密码
#spawn ${dir_easyrsa}/easyrsa build-client-full $User
#    expect {
#    "phrase?" {send "$Password\r";exp_continue}
#    "phrase:" {send "$Password\r";exp_continue}
#    "ca.key:" {send "$Password\r";exp_continue}
#    }
#    interact
#    expect eof
#    EOF

#cp $User_crt/$User.crt $User_key/$User.key $Server_crt/ca.crt $Secret_key/ta.key $User_dir
# create user.ovpn file
cat >> $User_dir/$User.ovpn << EOF
client
dev tun
# 定义Windows下使用的网卡名称,linux不需要
;dev-node MyTap
proto udp
remote 192.168.1.100 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
keepalive 10 120
# ADSL 模式避免错误
route-method exe
comp-lzo
verb 3
# 使用嵌入的tls密钥,需要添加否则则报错
key-direction 1
;askpass pass
EOF

# 写入证书到$user.opvn file,而不是使用文件
echo ""  >> $User_dir/$User.ovpn
echo ""  >> $User_dir/$User.ovpn

echo "<ca>" >> $User_dir/$User.ovpn
cat $Server_crt/ca.crt >> $User_dir/$User.ovpn
echo "</ca>" >> $User_dir/$User.ovpn
echo ""  >> $User_dir/$User.ovpn

echo "<tls-auth>" >> $User_dir/$User.ovpn
cat $Secret_key/ta.key >> $User_dir/$User.ovpn
echo "</tls-auth>" >> $User_dir/$User.ovpn
echo ""  >> $User_dir/$User.ovpn

echo "<cert>" >>  $User_dir/$User.ovpn
cat $User_crt/$User.crt >> $User_dir/$User.ovpn
echo "</cert>" >>  $User_dir/$User.ovpn
echo ""  >> $User_dir/$User.ovpn

echo "<key>" >>  $User_dir/$User.ovpn
cat $User_key/$User.key >> $User_dir/$User.ovpn
echo "</key>" >> $User_dir/$User.ovpn

# 打包文件为zip
cd /etc/openvpn/client-cert
zip -r /root/install/zip-client/$User.zip $User.ovpn

# nat映射，openvpn服务器配置，不然无法访问互联网
# ip:tables -t nat -A POSTROUTING -s 10.8.0.0/255.255.255.0 -o eth0 -j SNAT --to-source 192.168.26.95
