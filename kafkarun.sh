docker compose down
rm -fr docker-compose.yml
docker rmi -f $(docker images -a -q)
cp docker-compose-kafka.yml docker-compose.yml
export DEBEZIUM_VERSION=3.3
SRCMYSQL="34.200.232.217"
SINKMYSQL="44.202.186.124"
docker compose up -d
sleep 60
curl https://www.sqlines.com/downloads/Exasol_JDBC-25.2.4.tar.gz --output Exasol_JDBC-25.2.4.tar.gz
tar -zxvf Exasol_JDBC-25.2.4.tar.gz
curl https://www.sqlines.com/downloads/debezium-sink-exasol-0.0.1-SNAPSHOT.jar --output debezium-sink-exasol-0.0.1-SNAPSHOT.jar
tar -zxvf debezium-sink-exasol-0.0.1.tar.gz
docker cp Exasol_JDBC-*/exajdbc.jar connect:/kafka/connect/debezium-connector-jdbc/
docker cp Exasol_JDBC-*/exajload.jar connect:/kafka/connect/debezium-connector-jdbc/
docker cp debezium-sink-exasol-0.0.1-SNAPSHOT.jar connect:/kafka/connect/debezium-connector-jdbc/
chmod +x ./exregister_connectors.sh
./exregister_connectors.sh ${SRCMYSQL} ${SINKMYSQL}
