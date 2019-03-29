#!/bin/bash

JAVA_HOME=/java/jdk1.8.0_74/
TOMCAT_HOME=/wdzj/java/tomcat_8080
TOMCAT_PORT=8080
export JAVA_HOME
RED='\033[0;31m'
NC='\033[0m' # No Color

function red_echo {
    printf "${RED}$1${NC}\n"
}

WAR_api=/root/install/$1
#WAR_task=$2
echo "$0 starts at `date` install file = $WAR_api"
if ! [ -f $WAR ]; then
  echo "file $WAR not found!"
  exit 1
fi
function deploy_env {
   red_echo "#################################"
   rm -rf /java/env
   cp -r /root/install/env /java
}

function deploy_tomcat {
    red_echo '#################################'
    red_echo "deploying  $1  Port: $2"
    red_echo '#################################'

    red_echo '#################################'
    red_echo "killing tomcat1"
    red_echo '#################################'

    $1/bin/shutdown.sh
    sleep 3
    ps -ef|grep "$1\>"|grep -v grep|awk '{print $2}'|while read line;do kill -9 $line;done
    sleep 2

    red_echo '#################################'
    red_echo "removing old deployment"
    red_echo '#################################'
    rm -rf $1/ROOT_old
    mv -f $1/webapps/ROOT $1/ROOT_old

    red_echo '#################################'
    red_echo "unzip WAR_api"
    red_echo '#################################'
    unzip -d $1/webapps/ROOT $WAR_api
    red_echo '#################################'
    red_echo "starting tomcat"
    red_echo '#################################'
    $1/bin/startup.sh
    red_echo '#################################'
    red_echo "checking status"
    red_echo '#################################'
    for i in `seq 5`; do
        wget -t 1 -T 1 -q -O - "http://127.0.0.1:$2/version/status.do"
        printf '.'
        sleep 1
    done
}

#deploy_tomcat $TOMCAT01_HOME $TOMCAT01_PORT
#echo
#red_echo "Press Enter to deploy tomcat2\n"
#read
deploy_env
deploy_tomcat $TOMCAT_HOME $TOMCAT_PORT

sleep 10

