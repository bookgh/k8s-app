#!/bin/bash

KAFKA_HOST=$(hostname -i)
KAFKA_CMD="/opt/kafka/bin/kafka-producer-perf-test.sh"
OPTION="--num-records 5 --record-size 2 --throughput 10"
TOPIC_NAME="monitor"

nc -vw 3 $KAFKA_HOST -z 9092 >& /dev/null
if [ $? -eq 0 ];then
　　${KAFKA_CMD} ${OPTION} --topic ${TOPIC_NAME} --producer-props bootstrap.servers=${KAFKA_HOST}:9092 > /dev/null
　　if [ $? -ne 0 ];then
　　　　return 1
　　else
　　　　return 0
　　fi
else
    return 1
fi
