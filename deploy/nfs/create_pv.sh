#!/bin/bash

read -p '请输入 pvc 名称:' PVC_NAME
read -p '请输入 pvc 容量(100Gi):' STORAGE_SIZE
read -p '请输 namespace(default|kube-system):' NAME_SPACE

NAME_SPACE=${NAME_SPACE:-default}

if [ -z "$PVC_NAME"  ]; then
    echo "Usage: $0 pv_name storage_size [namespace: default]"
    exit 1
fi

if [ -z "$STORAGE_SIZE"  ]; then
    echo "Usage: $0 pv_name storage_size [namespace: default]"
    exit 1
fi

function create_pv(){
cat <<EOF | kubectl create -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: $PVC_NAME
  namespace: $NAME_SPACE
spec:
  storageClassName: nfs-example
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: $STORAGE_SIZE
EOF
}

create_pv
