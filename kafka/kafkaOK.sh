#!/usr/bin/env bash

TOPIC_NAME="monitor"
KAFKA_HOST="$(hostname -i)"
KAFKA_CMD="/opt/kafka/bin/kafka-producer-perf-test.sh"
OPTION="--num-records 5 --record-size 2 --throughput 10"

nc -vw 3 ${KAFKA_HOST} -z 9092 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    timeout 10s sh ${KAFKA_CMD} ${OPTION} --topic ${TOPIC_NAME} --producer-props bootstrap.servers=${KAFKA_HOST}:9092 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        exit 1
    else
        exit 0
    fi
else
    exit 1
fi
