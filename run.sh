
export DEBEZIUM_VERSION=3.3
docker compose up -d
sleep 60
chmod +x ./exregister_connectors.sh
./exregister_connectors.sh 34.232.51.67 44.201.54.90
