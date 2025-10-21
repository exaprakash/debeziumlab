rm -fr jarmover 
mkdir jarmover
cd jarmover
curl https://www.sqlines.com/downloads/debezium-sink-exasol-0.0.1.tar.gz --output debezium-sink-exasol-0.0.1.tar.gz
tar -zxvf debezium-sink-exasol-0.0.1.tar.gz
docker cp debezium-sink-exasol-0.0.1-SNAPSHOT.jar debezium:/debezium/lib/
curl https://www.sqlines.com/downloads/Exasol_JDBC-25.2.4.tar.gz --output Exasol_JDBC-25.2.4.tar.gz
tar -zxvf Exasol_JDBC-25.2.4.tar.gz
docker cp Exasol_JDBC-*/exajdbc.jar debezium:/debezium/lib/
docker cp Exasol_JDBC-*/exajload.jar debezium:/debezium/lib/

