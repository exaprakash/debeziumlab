ARG DEBEZIUM_VERSION
FROM quay.io/debezium/connect:${DEBEZIUM_VERSION}

RUN cd /debezium/lib
RUN curl -O https://repo1.maven.org/maven2/io/debezium/debezium-sink-jdbc/3.3.0.Final/debezium-sink-jdbc-3.3.0.Final.jar
RUN chown -R jboss:root /debezium/lib
