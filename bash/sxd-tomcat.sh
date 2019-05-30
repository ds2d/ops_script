#!/bin/bash
# deploy sxd tomcat

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
package=$(grep -i -Eo "[a-z-]+\.war" $1_settings/settings.json)



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
jar -uvf $jar_dir WEB-INF/classes/conf.properties

echo "4. Copy $project to remote server $services, and restart services"

for server in $services
do
    scp -P $port $jar_dir root@$server:/root/install/${project}_${date}.war
    ssh -p $port root@$server << EOF
    echo "Stop tomcat......"
    cd /wdzj/java/tomcat_8080
    sh bin/shutdown.sh
    ps -ef|grep -w "tomcat_8080"|grep -v grep|awk '{print $2}'|while read line;do kill -9 $line;done
    echo "Stop tomcat done!"

    rm -rf /wdzj/java/tomcat_8080/webapps/*
    echo "Start tomcat......"
    cp /root/install/${project}_${date}.war /wdzj/java/tomcat_8080/webapps/$package
    sh /wdzj/java/tomcat_8080/bin/startup.sh
    sleep 3
    echo "Start tomcat Finished!"
EOF

done
