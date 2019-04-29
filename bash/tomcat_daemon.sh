#!/bin/bash
# Jar|tomcat daemon
# 2018-10-19

TOMCATS="tomcat_8080"

function tomcat_daemon() {
    for tomcat in ${TOMCATS}
    do
        pid="$(ps ax --width=1000|grep "[o]rg.apache.catalina.startup.Bootstrap start"|grep -w ${tomcat}|awk '{print $1}')"
        # port="$(netstat -tnlp|grep ${pid}|grep -v grep|grep -v "127.0.0.1"|awk '{print $4}'|awk -F: '{print $NF}')"
        #pid="$(ps ax --width=1000|grep -v grep|grep -w ${tomcat}|awk '{print $1}')"
        if [[ "x${pid}" == "x" ]]
        then
            # echo "`date '+%F %T'` ERROR service ${tomcat} is stop_ped......"  >> /tmp/tomcat_status.txt
            kill ${pid}
            cd /wdzj/java/${tomcat}
            /bin/bash bin/startup.sh
            sleep 3
        else
           echo -e "\033[32mOK service ${tomcat} is running......[${pid}]\033[0m"
        fi
    done
}

tomcat_daemon
