#!/bin/bash
Kafka_home="/data/kafka"
DATE=`date`
Kafka_pid="$(ps aux|grep "/data/kafka/bin"|grep -v grep|awk '{print $2}')"
if [[ "x${Kafka_pid}" == "x" ]]
then
    echo "kafka is stopped ......${DATE}" >> /tmp/bblink_kafka_status.txt
    /usr/bin/nohup /bin/bash  ${Kafka_home}/bin/kafka-server-start.sh ${Kafka_home}/config/server.properties > /tmp/kafka_nohup.out 2>&1 &
else
    echo "kafka is running ......" > /dev/null
fi

