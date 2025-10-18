
export DEBEZIUM_VERSION=3.3
docker compose up -d
sleep 60
chmod +x ./register_connectors.sh
./register_connectors.sh
