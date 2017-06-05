FROM java:openjdk-8-jre-alpine

MAINTAINER Trevor Hartman <trevorhartman@gmail.com>

ARG MIRROR=http://apache.mirrors.pair.com

# does not support SSL
ARG VERSION=3.4.9

LABEL name="zookeeper" version=$VERSION

RUN apk add --no-cache curl wget bash tar \
    && mkdir -p /zookeeper/data /zookeeper/wal /zookeeper/log \
    && wget -q -O - $MIRROR/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz | \
         tar -xzf - --strip-components=1 -C /zookeeper \
    && apk del wget tar \
    && rm -rf \
      /tmp/* \
      /var/cache/apk/* \
      /zookeeper/contrib/fatjar \
      /zookeeper/dist-maven \
      /zookeeper/docs \
      /zookeeper/src \
      /zookeeper/bin/*.cmd

# Disable DNS cache
# RUN echo "networkaddress.cache.ttl=0" >> \
#   /usr/lib/jvm/default-jvm/jre/lib/security/java.security

ADD  conf /zookeeper/conf/
COPY bin/zkReady.sh /zookeeper/bin/
COPY bin/zkOk.sh /zookeeper/bin/
COPY entrypoint.sh /

ENV PATH=/zookeeper/bin:${PATH} \
    ZOO_LOG_DIR=/zookeeper/log \
    ZOO_LOG4J_PROP="INFO, CONSOLE, ROLLINGFILE" \
    JMXPORT=9010

#USER zookeeper

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "zkServer.sh", "start-foreground" ]

EXPOSE 2181 2281 2888 3888 9010
