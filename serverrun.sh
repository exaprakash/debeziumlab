rm -fr docker-compose.yml
export DEBEZIUM_VERSION=3.3
cp docker-compose-server.yml docker-compose.yml
docker compose down
docker rmi -f $(docker images -a -q)
docker compose up -d
