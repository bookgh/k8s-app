#!/bin/bash

# 容器启动后检测如果成功继续启动下一个副本，否则下一个副本不会启动
function status(){
    if [ "$1" = "storage" ]; then
        PORT=23000
        # wait create storage data directory
        for ((i=0;i<=2;i++)); do
            if [ ! -d "${STORAGE_DATA}/data/FF/FF" ]; then
                i=0
                echo "wait create storage data directory: ${STORAGE_DATA}/data . "
                sleep 3
            fi
        done
    elif [ "$1" = "tracker" ]; then
        PORT=22122
    fi

    # check service status
    nc -vw 3 localhost -z $PORT > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        echo "---> Port: $PORT 没有监听."
        return 1
    fi
}

# 容器运行中定时检查健康状态,异常则重启pod
function monitor (){
    # tracker
    if [ "$1" == "tracker" ]; then
        nc -vw 3 localhost -z 23000 >& /dev/null
        if test $? -eq 0; then
            storage_num=$(fdfs_monitor /etc/fdfs/client.conf -h $(hostname -i) | grep 'ip_addr' | wc -l)
            STORAGE_SERVER_NUM=$(tr_list=($TRACKERSERVER); echo ${#tr_list[@]})
            if [ $storage_num -gt $STORAGE_SERVER_NUM ]; then
                echo '---> Tracker is down'
                return 1
            else
                return 0
            fi
        fi
    fi

    # starage
    if [ "$1" == "storage" ]; then
        info=$(fdfs_monitor /etc/fdfs/storage.conf | grep $HOSTNAME | awk '{print $NF}')
        if [ "$info" == "ACTIVE" ]; then
            return 0
        else
            echo '---> Storage is down'
            return 1
        fi

        num=$(wget -q -O /dev/null -S localhost:8888 2>&1 | grep 200 | wc -l)
        if [ $num -eq 1 ]; then
            return 0
        else
            echo '---> Nginx is down'
            return 1
        fi
    fi
}

case $2 in
    monitor)
        monitor $1 ;;
    status)
        status $1 ;;
    *)
        echo "Usage: $0 {storage|tracker} {status|monitor}" ;;
esac
