docker stop debezium-server-exasol
docker rmi -f $(docker images -a -q)
docker run -d \
  --name debezium-server-exasol \
  -v ./application.yml:/debezium/conf/application.yaml \
  quay.io/debezium/server:3.3
