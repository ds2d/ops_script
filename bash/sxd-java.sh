#!/bin/bash
# deploy sxd project

config_dir=$1
branchs=$2
date=$(date +"%F")

services=$(grep -Po '(\d+\.){3}\d+' $1_settings/settings.json)
port=$(grep -Po 'port[": ]+\K[^"]+' $1_settings/settings.json)
#username=$(grep -Po 'username[": ]+\K[^"]+' $1_settings/settings.json)
#password=$(grep -Po 'password[": ]+\K[^"]+' $1_settings/settings.json)
project=$(grep -Po 'project[": ]+\K[^"]+' $1_settings/settings.json)
pomfile=$(grep -Po 'pom[": ]+\K[^"]+' $1_settings/settings.json)
jar_dir=$(grep -Po 'jar[": ]+\K[^"]+' $1_settings/settings.json)
#package=$(grep -Po 'jar[": ]+\K[^"]+' $1_settings/settings.json|awk -F'/' '{print $NF}')
package=$(grep -i -Eo "[a-z-]+\.jar" $1_settings/settings.json)



cp -R $1_settings/. .

# Clone the project code and build

echo "1. Clone $project source code!"
if [ "$#" -eq 2 ]; then
    git clone -b $branchs git@gitlab.com:root/$project.git
else
    git clone git@gitlab.com:root/$project.git
fi

echo "2. Cloning complete, maven build!"
mvn -f $pomfile clean install -e -U
if [ "$?" -ne 0 ];then
    echo "maven 打包失败!"
    exit 500
fi

# Update the project package
echo "3. Update $package config file!"
jar -uvf $jar_dir conf.properties configs/server.properties

echo "4. Copy $project to remote server $services, and restart services"

for server in $services
do
    echo "upload file"
    ssh -p $port root@$server "mkdir -p /wdzj/java/service/{bin,java}"
    ssh -p $port root@$server "mkdir -p /wdzj/java/service/java/configs"

    scp -P $port $jar_dir root@$server:/root/install/${project}_${date}.jar
    scp -P $port $jar_dir root@$server:/wdzj/java/service/java/$package
    scp -P $port java_manager.sh  root@$server:/wdzj/java/service/bin/java_manager.sh
    scp -P $port conf.properties  root@$server:/wdzj/java/service/java/conf.properties
    scp -P $port configs/server.properties root@$server:/wdzj/java/service/java/configs/server.properties
    echo "upload done!"

    echo "restart service"
    ssh -p $port  root@$server "cd /wdzj/java/service;sh bin/java_manager.sh java/$package stop"
    ssh -p $port  root@$server "cd /wdzj/java/service;sh bin/java_manager.sh java/$package start"
    
done
