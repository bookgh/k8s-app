#!/bin/sh

# 创建数据目录
mkdir -p $STORAGE_DIR/data $TRACKER

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
echo '---> start trackerd'
/etc/init.d/fdfs_trackerd start

sleep 5
echo '---> start storage'
/etc/init.d/fdfs_storaged start
