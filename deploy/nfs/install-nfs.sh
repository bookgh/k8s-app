#!/bin/bash

# 安装 Nfs Server
yum install -y nfs-utils

# 配置资源
echo '/data/example *(rw,sync,insecure,no_subtree_check,no_root_squash)' > /etc/exports

# 创建数据目录
mkdir -p /data/example

# 启动服务跟随系统启动
systemctl start nfs
systemctl restart nfs
systemctl enable nfs

# 验证
showmount -e localhost
