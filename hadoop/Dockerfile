FROM java:8-jre

MAINTAINER xiongjunfeng@haocang.com

ENV TZ=Asia/Shanghai \
    HADOOP_VER=2.7.7 \
    HADOOP_HOME=/usr/local/hadoop

ENV HADOOP_PREFIX=$HADOOP_HOME \
    HADOOP_HDFS_HOME=$HADOOP_HOME \
    HADOOP_YARN_HOME=$HADOOP_HOME \
    HADOOP_COMMON_HOME=$HADOOP_HOME \
    HADOOP_MAPRED_HOME=$HADOOP_HOME \
    HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop \
    PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# install hadoop
RUN wget -O hadoop.tar.gz http://soft.hc-yun.com/base/software/hadoop-${HADOOP_VER}.tar.gz \
  && tar -xzf hadoop.tar.gz -C /usr/local \
  && ln -s /usr/local/hadoop-${HADOOP_VER} /usr/local/hadoop \
  && rm -f hadoop.tar.gz

# timezone
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime

WORKDIR $HADOOP_HOME

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 19888

#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

#Other ports
EXPOSE 49707 2122
