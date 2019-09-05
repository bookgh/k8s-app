#!/bin/bash

# 容器启动后检测如果成功继续启动下一个副本，否则下一个副本不会启动
function status(){
    if [ "$FASTDFS_MODE" = "storage" ]; then
        PORT=23000
        # wait create storage data directory
        for ((i=0;i<=2;i++)); do
            if [ ! -d "${STORAGE_DATA}/data/FF/FF" ]; then
                i=0
                echo "wait create storage data directory: ${STORAGE_DATA}/data . "
                sleep 3
            fi
        done
    elif [ "$FASTDFS_MODE" = "tracker" ]; then
        PORT=22122
    fi

    # check service status
    nc -vw 3 localhost -z $PORT > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# 容器运行中定时检查健康状态,异常则重启pod
function monitor (){
    # tracker
    if [ "$FASTDFS_MODE" == "tracker" ]; then
        nc -vw 3 fastdfs-storage-svc -z 23000 >& /dev/null
        if test $? -eq 0; then
            storage_num=$(fdfs_monitor /etc/fdfs/client.conf -h $(hostname -i) | grep 'ip_addr' | wc -l)
            if [ $storage_num -gt $STORAGE_SERVER_NUM ]; then
                return 1
            else
                return 0
            fi
        fi
    fi

    # starage
    if [ "$FASTDFS_MODE" == "storage" ]; then
        info=$(fdfs_monitor /etc/fdfs/storage.conf | grep $HOSTNAME | awk '{print $NF}')
        if [ "$info" == "ACTIVE" ]; then
            return 0
        else
            return 1
        fi
    fi
}

case $1 in
    monitor)
        monitor ;;
    status)
        status ;;
    *)
        echo "Usage: $0 {status|monitor}" ;;
esac
