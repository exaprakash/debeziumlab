docker compose down
rm -fr docker-compose.yml
docker rmi -f $(docker images -a -q)
cp docker-compose-srcmysql.yml docker-compose.yml
docker compose up -d
