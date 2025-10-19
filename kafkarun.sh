cp docker-compose-kafka.yml docker-compose.yml
export DEBEZIUM_VERSION=3.3
SRCMYSQL="13.218.185.65"
SINKMYSQL="3.239.235.43"
docker compose up -d
sleep 60
chmod +x ./exregister_connectors.sh
./exregister_connectors.sh ${SRCMYSQL} ${SINKMYSQL}
