export DEBEZIUM_VERSION=3.3
docker compose down
docker rmi -f $(docker images -a -q)
rm -fr docker-compose.yml
cp docker-compose-server.yml docker-compose.yml
docker compose up -d
