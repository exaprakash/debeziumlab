ARG DEBEZIUM_VERSION
FROM quay.io/debezium/server:${DEBEZIUM_VERSION}

RUN cd /tmp && \
    curl -O https://repo1.maven.org/maven2/io/debezium/debezium-sink-jdbc/3.3.0.Final/debezium-sink-jdbc-3.3.0.Final.jar && \
    mv debezium-sink-jdbc-3.3.0.Final.jar /debezium/lib/

RUN chown -R jboss:root /debezium/lib
