#! /bin/bash

ZIP=$1
NAME=java-jar

function deploy()
{
export JAVA_HOME=/java/jdk1.8.0_74
export JRE_HOME=$JAVA_HOME

service_name=$1
#jar_name=$2
#script_dir=/java/service/$service_name
service_dir=/java/service_${NAME}
javajar=java-${NAME}-service.jar
pid=app_name_$NAME\.pid
#cp $ZIP /java/service/$service_name-bin.zip

if [ ! -d ${service_dir} ]; then
    mkdir -p ${service_dir}
fi

# 停止当前jar进程
cd $service_dir
P_ID=`ps -ef | grep -w $javajar|grep -v "install" | grep -v "grep" | awk '{print $2}'`
if [ "$P_ID" == "" ]; then
    echo "=== $service_name process not exists or stop success"
else
    echo "=== $service_name process pid is:$P_ID"
    echo "=== begin kill $service_name process, pid is:$P_ID"
    kill -9 $P_ID
fi

rm -rf /java/env

cp -r /root/install/env /java/env
echo 1
echo $ZIP
echo /root/install/$ZIP
echo /java/service_${NAME}/${service_name}-bin.zip
echo 2


if [ -f "$service_name-bin.zip" ]; then
        #rm -rf $service_dir/$service_name-bin.zip
        #rm -rf $service_dir/$service_name
    echo ---$PWD
    rm -rf /java/service_${NAME}/*


    #cp  $jar_name-bin.zip $service_dir
    echo $ZIP
    cp /root/install/$ZIP $service_dir/$service_name-bin.zip

    cd $service_dir
    echo 12 $service_dir/$service_name-bin.zip
    unzip $service_dir/$service_name-bin.zip -d $service_dir
else
    echo $PWD
    echo "the $service_name-bin.zip is not exist..."
    cp /root/install/$ZIP $service_dir/$service_name-bin.zip

    cd $service_dir
    echo 1111 $service_dir/$service_name-bin.zip
    unzip $service_dir/$service_name-bin.zip -d $service_dir

fi

##启动当前jar进程
cd $service_dir
cd java-${NAME}-service
echo $PWD
nohup $JRE_HOME/bin/java -Dglobal.config.path=/java/env/ -Xms1024m -Xmx1024m -XX:PermSize=1024M -XX:MaxPermSize=1024m -Dfile.encoding=UTF-8 -jar $javajar >/tmp/$NAME 2>&1 &
echo $service_dir $javajar
echo $! > $service_dir/$pid
echo "=== start $service_name"

}


deploy java-${NAME}-service
