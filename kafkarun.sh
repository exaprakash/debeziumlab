docker compose down
rm -fr docker-compose.yml
docker rmi -f $(docker images -a -q)
cp docker-compose-kafka.yml docker-compose.yml
export DEBEZIUM_VERSION=3.3
SRCMYSQL="34.200.232.217"
SINKMYSQL="44.202.186.124"
docker compose up -d
sleep 60
chmod +x ./exregister_connectors.sh
./exregister_connectors.sh ${SRCMYSQL} ${SINKMYSQL}
