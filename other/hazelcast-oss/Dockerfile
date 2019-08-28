FROM alpine:3.8

# Versions of Hazelcast and Hazelcast plugins
ARG HZ_VERSION=3.9.1
ARG JMX_PROMETHEUS_AGENT_VERSION=0.11.0

# Build constants
ARG HZ_HOME="/opt/hazelcast"
ARG HZ_BIN="hazelcast-${HZ_VERSION}.tar.gz"

# Runtime constants / variables
ENV HZ_HOME="${HZ_HOME}" \
    CLASSPATH_DEFAULT="${HZ_HOME}/lib/*" \
    JAVA_OPTS_DEFAULT="-Djava.net.preferIPv4Stack=true -Djava.util.logging.config.file=${HZ_HOME}/logging.properties" \
    MIN_HEAP_SIZE="" \
    MAX_HEAP_SIZE="" \
    MANCENTER_URL="" \
    PROMETHEUS_PORT="" \
    PROMETHEUS_CONFIG="${HZ_HOME}/jmx_agent_config.yaml" \
    LOGGING_LEVEL="" \
    CLASSPATH="" \
    JAVA_OPTS=""

COPY *.xml *.sh *.yaml *.jar *.properties ${HZ_HOME}/

# Expose port
EXPOSE 5701

# Install
RUN echo "Updating Alpine system" \
    && apk upgrade --update-cache --available \
    && echo "Installing new APK packages" \
    && apk add openjdk8-jre bash curl procps nss \
    && echo "Installing Hazelcast" \
    && curl -sf -O http://kaifa.hc-yun.com:30027/base/software/$HZ_BIN \
    && tar xvf $HZ_BIN -C /opt \
    && echo "Installing JMX Prometheus Agent" \
    && curl -sf -o "${HZ_HOME}/lib/jmx_prometheus_javaagent.jar" \
         -L "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_AGENT_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_AGENT_VERSION}.jar" \
    && echo "Granting read permission to ${HZ_HOME}" \
    && chmod -R +r $HZ_HOME \
    && echo "Setting Pardot ID to 'docker'" \
    && echo 'hazelcastDownloadId=docker' > $HZ_HOME/hazelcast-download.properties \
    && echo "Cleaning APK packages" \
    && rm -rf /var/cache/apk/* $HZ_BIN

WORKDIR ${HZ_HOME}

# Start Hazelcast server
CMD ["/opt/hazelcast/start-hazelcast.sh"]

