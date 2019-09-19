FROM openjdk:8-jre-alpine

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JHIPSTER_SLEEP=0 \
    JAVA_OPTS="-Xmx1g -Xms1g -Duser.timezone=GMT+8"

CMD echo "The application will start in ${JHIPSTER_SLEEP}s..." && \
    sleep ${JHIPSTER_SLEEP} && \
    java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.war

EXPOSE 8761

ADD http://192.168.2.30:8090/mango/11f/war/jhipster-registry/registry-1.0.0.0002.war /app.war
ADD central-config /central-config
