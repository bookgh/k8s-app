#!/bin/bash

# source: stable/hadoop --version 1.1.1

# update
# version: 2.7.7

helm install --name hadoop  \
  --set persistence.nameNode.enabled=true \
  --set persistence.nameNode.storageClass=nfs-example \
  --set persistence.dataNode.enabled=true \
  --set persistence.dataNode.storageClass=nfs-example \
  --set image.repository=192.168.2.30/kubernetes/hadoop \
  --set image.tag=2.7.7 \
  --set hadoopVersion=2.7.7 \
  --set hdfs.dataNode.replicas=3 \
  hadoop

# 增加DataNode节点数量
# helm upgrade hadoop --set hdfs.dataNode.replicas=3 hadoop
