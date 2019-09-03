#!/bin/bash

# service check
if [ "$FASTDFS_MODE" == "storage" ]; then
    info=$(fdfs_monitor /etc/fdfs/storage.conf | grep $HOSTNAME | awk '{print $NF}')
    if [ "$info" == "ACTIVE" ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$FASTDFS_MODE" == "tracker" ]; then
    fdfs_monitor /etc/fdfs/client.conf -h $(hostname -i)
    if [ $? -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
fi
