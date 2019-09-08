#!/bin/bash

# set -x
FASTDFS_MODE=${FASTDFS_MODE:-$1}

# create data dir
mkdir -p $TRACKER_DATA $STORAGE_DATA/data

# delete tracker server config
sed -i "s|tracker_server=|# &|g" /etc/fdfs/client.conf
sed -i "s|tracker_server=|# &|g" /etc/fdfs/storage.conf
sed -i "s|tracker_server=|# &|g" /etc/fdfs/mod_fastdfs.conf

# config ttacker server
for node in $TRACKERSERVER; do
    sed -i "/# tracker_server=/a tracker_server=${node}:22122" /etc/fdfs/client.conf
    sed -i "/# tracker_server=/a tracker_server=${node}:22122" /etc/fdfs/storage.conf
    sed -i "/# tracker_server=/a tracker_server=${node}:22122" /etc/fdfs/mod_fastdfs.conf
done

# config data dir
sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/client.conf
sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/storage.conf
sed -i "s|base_path=.*|base_path=$TRACKER_DATA|g" /etc/fdfs/tracker.conf
sed -i "s|base_path=.*|base_path=$STORAGE_DATA|g" /etc/fdfs/mod_fastdfs.conf
sed -i "s|group_count =.*|group_count = 1|g" /etc/fdfs/mod_fastdfs.conf
sed -i "s|url_have_group_name = .*|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf
if [ ! $(grep '^\[group1\]' /etc/fdfs/mod_fastdfs.conf) ]; then
    cat >> /etc/fdfs/mod_fastdfs.conf <<EOF
[group1]
group_name=group1
storage_server_port=23000
store_path_count=1
store_path0=$STORAGE_DATA
EOF
fi

sed -i "s|store_path0=.*|store_path0=$STORAGE_DATA|g" /etc/fdfs/storage.conf
sed -i "s|store_path0=.*|store_path0=$STORAGE_DATA|g" /etc/fdfs/mod_fastdfs.conf

# start tracker
function fdfs_tracker(){
    echo '---> start trackerd'
    /etc/init.d/fdfs_trackerd start
    tail -f /dev/null
}

# start storage
function fdfs_storage(){
    LIST_TR=($TRACKERSERVER)
    NUM=${#LIST_TR[@]}
    i=0
    while [ $i -lt $NUM ]; do
        i=0
        for node in $TRACKERSERVER; do
            # tracker status
            nc -vw 3 $node -z 22122 >& /dev/null
            if [ $? -eq 0 ]; then
                let i++
            else
                echo "---> wait $node port 22122 up"
            fi
            sleep 3
        done
    done
    sleep 3
    echo '---> start storage'
    /etc/init.d/fdfs_storaged start
    tail -f /dev/null
}

# start nginx
function fdfs_nginx(){
    LIST_TR=($TRACKERSERVER)
    NUM=${#LIST_TR[@]}
    i=0
    while [ $i -lt $NUM ]; do
        i=0
        for node in $TRACKERSERVER; do
            # storage status
            nc -vw 3 $node -z 23000 >& /dev/null
            if [ $? -eq 0 ]; then
                let i++
            else
                echo "---> wait $node port 23000 up"
            fi
            sleep 3
        done
    done
    sleep 3
    echo '---> start nginx'
    echo "<h1>$HOSTNAME  <------>  $(hostname -i)</h1>" >> /usr/share/nginx/html/index.html
    /usr/sbin/nginx -g 'daemon off;'
}

case $FASTDFS_MODE in
    tracker)
      fdfs_tracker ;;
    storage)
      fdfs_storage ;;
    nginx)
      fdfs_nginx ;;
    *)
      echo "Usage: $0 {tracker|storage|nginx}" ;;
esac
