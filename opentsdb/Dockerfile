FROM java:8-jre

MAINTAINER xiongjunfeng@haocang.com

ENV TSDB_VER=2.4.0 \
    TZ=Asia/Shanghai

COPY sources.list.debian /etc/apt/sources.list

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime \
  && apt-get update; apt-get install --no-install-recommends -y gnuplot-nox \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/OpenTSDB/opentsdb/releases/download/v${TSDB_VER}/opentsdb-${TSDB_VER}_all.deb \
  && dpkg -i opentsdb-${TSDB_VER}_all.deb \
  && rm -rf opentsdb-${TSDB_VER}_all.deb

COPY logback.xml /etc/opentsdb/logback.xml

EXPOSE 14242
