#!/bin/bash
# jar daemon

export JAVA_HOME=/wdzj/java/jdk1.8.0_74
export JRE_HOME=$JAVA_HOME

service_name="creditcardmgm-job creditcardmgm-mq"


function Jar_daemon(){
    for jar in ${service_name}
    do
        javajar=$(ls /wdzj/java/service_$jar/basics-$jar-service |grep $jar)
        pid="$(ps aux|grep -w "${javajar}"|grep -v grep|awk '{print $2}')"
        # port="$(netstat -tnlp|grep ${pid}|cut -d: -f4)"
        if [[ "x${pid}" == "x" ]]
        then
            echo "`date '+%F %T'` ERROR service ${javajar} is Stopped......" >> /tmp/jarstatus
            kill ${pid}
            # /bin/bash /root/install/jar-daemon.sh start
            cd /wdzj/java/service_$jar
            cd basics-$jar-service
            echo $PWD
            nohup $JRE_HOME/bin/java -Dglobal.config.path=/wdzj/java/env/ -Xms1500m -Xmx1500m -Dfile.encoding=UTF-8 -jar $javajar >/tmp/$jar 2>&1 &
            # echo ${service_dir} ${javajar}
            echo $! > /wdzj/java/service_${jar}/app_name_${jar}.pid
            echo "=== Ok started ${javajar}"
            # gre_echo "Pid is $(cat ${pid_file})"
            sleep 3
        else
           echo -e "\033[32mOK service ${jar} is running......[${pid}]\033[0m"
        fi
   done
}
Jar_daemon
