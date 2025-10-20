docker compose down
rm -fr docker-compose.yml
docker rmi -f $(docker images -a -q)
cp docker-compose-sinkmysql.yml docker-compose.yml
docker compose up -d
