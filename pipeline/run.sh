#!/bin/bash
# build

. /etc/profile

cd $(ls -ld /data/* | grep "^d"|awk '{print $NF}')
javajar=$(ls  /data/* | grep -E "*.jar")
echo "Start project......"
mx=${Xmx:-1500m}
ms=${Xms:-1500m}

JAVA_MEM_OPTS=" -Dglobal.config.path=/root/config/env/  -Xmx${mx} -Xms${ms} -Dfile.encoding=UTF-8" 
/usr/local/jdk1.8.0_74/bin/java $JAVA_MEM_OPTS -jar $javajar
