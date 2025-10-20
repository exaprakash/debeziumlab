ARG DEBEZIUM_VERSION
FROM quay.io/debezium/connect:${DEBEZIUM_VERSION}

ARG JMX_AGENT_VERSION
RUN mkdir /kafka/etc && cd /kafka/etc &&\
        curl -so jmx_prometheus_javaagent.jar \
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_AGENT_VERSION/jmx_prometheus_javaagent-$JMX_AGENT_VERSION.jar
RUN cd /kafka &&\
        curl https://www.sqlines.com/downloads/Exasol_JDBC-25.2.4.tar.gz --output Exasol_JDBC-25.2.4.tar.gz
        tar -zxvf Exasol_JDBC-25.2.4.tar.gz && cp Exasol_JDBC-*/exajdbc.jar /kafka/connect/debezium-connector-jdbc/ && cp Exasol_JDBC-*/exajload.jar /kafka/connect/debezium-connector-jdbc/

RUN cd /kafka &&\
        curl https://www.sqlines.com/downloads/debezium-sink-exasol-0.0.1.tar.gz --output debezium-sink-exasol-0.0.1.tar.gz &&\
        tar -zxvf debezium-sink-exasol-0.0.1.tar.gz  && cp debezium-sink-exasol*.jar /kafka/connect/debezium-connector-jdbc

RUN chown -R kafka:kafka /kafka/connect/debezium-connector-jdbc/
COPY config.yml /kafka/etc/config.yml
