#!/bin/bash

# source: stable/hadoop --version 1.1.1

# update
# version: 2.7.7

helm install --name hadoop  \
  --set persistence.nameNode.enabled=true \
  --set persistence.nameNode.storageClass=nfs-example \
  --set persistence.dataNode.enabled=true \
  --set persistence.dataNode.storageClass=nfs-example \
  --set image.repository=192.168.0.75/kubernetes/hadoop \
  --set image.tag=2.7.7 \
  --set hadoopVersion=2.7.7 \
  --set hdfs.dataNode.replicas=3 \
  hadoop


# version: 1.2.12
helm install --name hbase \
  --set image.tag=1.2.12 \
  --set image.repository=192.168.0.75/kubernetes/hbase \
  --set hbase.hadoop.rootdir=hadoop-hadoop-hdfs-nn:9000 \
  --set hbase.zookeeper.quorum=zk-0.zk-svc.default.svc.cluster.local,zk-1.zk-svc.default.svc.cluster.local,zk-2.zk-svc.default.svc.cluster.local \
  hbase
