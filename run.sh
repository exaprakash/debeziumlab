
export DEBEZIUM_VERSION=3.3
SRCMYSQL="34.232.51.67"
SINKMYSQL="44.201.54.90"
docker compose up -d
sleep 60
chmod +x ./exregister_connectors.sh
./exregister_connectors.sh ${SRCMYSQL} ${SINKMYSQL}
