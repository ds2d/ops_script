#!/bin/bash
cat << EOF
#使用 $0 -f filename 指定存储主机/端口/密码/新密码的文件
#filename 文件格式为: 主机ip  端口 原密码  新密码
EOF

if [ $# -lt 2 ]
 then 
  echo  "输入方式错误，请使用 $0  -f  filename" 
  exit
fi

for i in `awk '{print $1}' $2`
do
x=`awk /${i}/'{print $2}' $2`
y=`awk /${i}/'{print $3}' $2`
z=`awk /${i}/'{print $4}' $2`
expect ./change-expect.exp ${i} ${x} ${y} ${z}
done
