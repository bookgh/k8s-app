FROM java:8-jre

MAINTAINER xiongjunfeng@haocang.com

ENV TZ=Asia/Shanghai \
    HBASE_VER=1.2.12 \
    HBASE_HOME=/usr/local/hbase

ENV HBASE_DATA_DIR=$HBASE_HOME/hbase \
    HBASE_ZK_DATA_DIR=HBASE_HOME/zookeeper \
    PATH=$PATH:$HBASE_HOME/bin:$HBASE_HOME/sbin

RUN wget -O hbase.tar.gz http://soft.hc-yun.com/base/software/hbase-${HBASE_VER}-bin.tar.gz \
  && tar -xzf hbase.tar.gz -C /usr/local \
  && ln -s /usr/local/hbase-${HBASE_VER} $HBASE_HOME \
  && mkdir -p $HBASE_DATA_DIR $HBASE_ZK_DATA_DIR \
  && rm -f hadoop.tar.gz

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime

WORKDIR $HBASE_HOME

# Master port
EXPOSE 16000

# Master info port
EXPOSE 16010

# Regionserver port
EXPOSE 16020

# Regionserver info port
EXPOSE 16030
