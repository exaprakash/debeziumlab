curl https://www.sqlines.com/downloads/Exasol_JDBC-25.2.4.tar.gz --output Exasol_JDBC-25.2.4.tar.gz
tar -zxvf Exasol_JDBC-25.2.4.tar.gz
curl https://www.sqlines.com/downloads/debezium-sink-exasol-0.0.1-SNAPSHOT.jar --output debezium-sink-exasol-0.0.1-SNAPSHOT.jar
tar -zxvf debezium-sink-exasol-0.0.1.tar.gz
docker cp Exasol_JDBC-*/exajdbc.jar connect:/kafka/connect/debezium-connector-jdbc/
docker cp Exasol_JDBC-*/exajload.jar connect:/kafka/connect/debezium-connector-jdbc/
docker cp debezium-sink-exasol-0.0.1-SNAPSHOT.jar connect:/kafka/connect/debezium-connector-jdbc/
