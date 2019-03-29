#!/bin/bash
# auto passwd
# 2018-06-26
# auth liubb

number=$1
length=15
for i in `seq 1 $number`;
do
    if [ $length -gt 20 ];then
    length=15
    fi
    < /dev/urandom tr -dc A-Za-z0-9 | head -c $length
#  cat /dev/urandom |tr -dc A-Za-z0-9|head -c $length
#  openssl rand -base64 30|cut -c 1-20|tr -d "/+"
    echo
    length=$[ $length+1 ]
done

