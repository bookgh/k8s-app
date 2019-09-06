#!/bin/sh

# 创建数据目录
mkdir -p $STORAGE_DIR/data $TRACKER_DIR

# 注释 TRACKER SERVER
sed -i "/^tracker_server/d" /etc/fdfs/client.conf;
sed -i "/^tracker_server/d" /etc/fdfs/storage.conf;
sed -i "/^tracker_server/d" /etc/fdfs/tracker.conf;

# 配置 TRACKER SERVER
TRACKERSERVER=${TRACKERSERVER:-localhost}
for node in $TRACKERSERVER; do
    echo "tracker_server=$node:$FDFS_PORT"  >> /etc/fdfs/client.conf
    echo "tracker_server=$node:$FDFS_PORT"  >> /etc/fdfs/storage.conf
    echo "tracker_server=$node:$FDFS_PORT"  >> /etc/fdfs/tracker.conf
done

# 启动服务
if [ "$1" == 'tracker' ]; then
    echo '---> start trackerd'
    /etc/init.d/fdfs_trackerd start
    tail -f /dev/null
elif [ "$1" == 'storage' ]; then
    sleep 5
    ARG=true
    while $ARG; do
        for node in $TRACKERSERVER; do
            nc -vw 3 $node -z  22122 >& /dev/null
            if [ $? -eq 0 ]; then
                ARG=false
            else
                echo "---> wait $node port 22122 up"
            fi
            sleep 1
        done
    done
    sleep 3
    echo '---> start storage'
    /etc/init.d/fdfs_storaged start
    tail -f /dev/null
fi

# /usr/local/nginx/sbin/nginx
