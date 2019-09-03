#!/bin/bash

# set -x

# 注释旧的配置
sed -i "s|tracker_server=|# &|g" /etc/fdfs/client.conf
sed -i "s|tracker_server=|# &|g" /etc/fdfs/storage.conf
sed -i "s|tracker_server=|# &|g" /etc/fdfs/mod_fastdfs.conf

# 配置 TRACKER_SERVER
TRACKER_SERVER_NUM=${TRACKER_SERVER_NUM:-2}
TRACKER_NUM=$((TRACKER_SERVER_NUM-1))
for ((i=$TRACKER_NUM; i>=0; i--)); do
    sed -i "/# tracker_server=/a tracker_server=fastdfs-tracker-${i}.fastdfs-tracker-svc:22122" /etc/fdfs/client.conf
    sed -i "/# tracker_server=/a tracker_server=fastdfs-tracker-${i}.fastdfs-tracker-svc:22122" /etc/fdfs/storage.conf
    sed -i "/# tracker_server=/a tracker_server=fastdfs-tracker-${i}.fastdfs-tracker-svc:22122" /etc/fdfs/mod_fastdfs.conf
done

if [ "$FASTDFS_MODE" = "storage" ]; then
  PORT=23000
  FASTDFS_MODE="storage"
  mkdir -p $STORAGE_DATA

  sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/client.conf
  sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/storage.conf
  sed -i "s|store_path0=.*|store_path0=$STORAGE_DATA|g" /etc/fdfs/storage.conf
  sed -i "s|store_path0=.*|store_path0=$STORAGE_DATA|g" /etc/fdfs/mod_fastdfs.conf
  sed -i "s|group_count =.*|group_count = 1|g" /etc/fdfs/mod_fastdfs.conf
  sed -i "s|url_have_group_name = .*|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf
  echo -e "\n[group1]\ngroup_name=group1\nstorage_server_port=23000\nstore_path_count=1\nstore_path0=$STORAGE_DATA" >>/etc/fdfs/mod_fastdfs.conf
elif [ "$FASTDFS_MODE" = "tracker" ]; then
  PORT=22122
  FASTDFS_MODE="tracker"
  mkdir -p $TRACKER_DATA $STORAGE_DATA

  sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/client.conf
  sed -i "s|base_path=.*|base_path=$TRACKER_DATA|g" /etc/fdfs/tracker.conf
fi

# start the fastdfs node.
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

# start nginx
if [ "$FASTDFS_MODE" = "storage" ]; then
  echo "<h1>$HOSTNAME $(hostname -I)</h1>" > /usr/local/nginx/html/index.html
  /usr/local/nginx/sbin/nginx

  # wait create storage directory
  for ((i=0;i<=5;i++)); do
    if [ ! -d "${STORAGE_DATA}/data/FF/FF" ]; then
      i=3
      ls ${STORAGE_DATA}/data
      echo "创建 storage 目录中... "
      sleep 3
    fi
  done
fi

# exit
function shut_down() {
    echo shutting down
    PID=$(ps -ef | grep "fdfs_${FASTDFS_MODE}d" | grep -v grep | awk '{print $1}' )
    kill -SIGTERM $PID
    exit 0
}

trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

# check service status
for ((i=0;i<=5;i++)); do
    nc -vw 3 localhost -z $PORT > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      i=0
      echo "$FASTDFS_MODE status: $i"
    else
      echo "$FASTDFS_MODE status: $i"
    fi
    sleep 2
done
