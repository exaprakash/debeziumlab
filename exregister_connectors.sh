#!/usr/bin/env bash

# $1 = source mysql host
# $2 = sink mysql host

SRC_HOST="$1"
SINK_HOST="$2"

if [ -z "$SRC_HOST" ] || [ -z "$SINK_HOST" ]; then
  echo "Usage: ./run.sh <source_host> <sink_host>"
  exit 1
fi

SRC_DB_URL="jdbc:mysql://${SRC_HOST}:3306/tpcc"
SINK_DB_URL="jdbc:mysql://${SINK_HOST}:3306/tpcc"

echo "Using SRC_DB_URL:  $SRC_DB_URL"
echo "Using SINK_DB_URL: $SINK_DB_URL"

rm -fr ./scripts/connector-templates
mkdir -p ./scripts/connector-templates
# curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-srcmysql.json
# curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-sinkmysql.json

# Connection to Kafka Connect REST
CONNECT_URL="http://localhost:8083/connectors/"
# Source DB connection
src_output_file="./scripts/connector-templates/register-srcmysql.json"
  cat > "$src_output_file" <<EOF
{
  "name": "src_tpcc_connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "${SRC_HOST}",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.id": "184054",
    "topic.prefix": "cdc",
    "database.include.list": "tpcc",
    "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
    "schema.history.internal.kafka.topic": "tpcc.schema_changes",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter.schemas.enable": "true"
  }
}
EOF
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" "${CONNECT_URL}"  -d @"${src_output_file}"


# Sink DB connection
# SINK_DB_URL="jdbc:mysql://${SINK_DB_URL}:3306/tpcc"
USERNAME="mysqluser"
PASSWORD="mysqlpw"
# Table → Partition count mapping
declare -A table_partitions=(
  ["warehouse"]=4
  ["district"]=8
  ["customer"]=48
  ["history"]=48
  ["orders"]=48
  ["new_order"]=48
  ["order_line"]=48
  ["item"]=4
  ["stock"]=48
)


# Generate and register connector per table
for table in "${!table_partitions[@]}"; do
  connector_name="sink_mysql_${table}"
  topic_name="cdc.tpcc.${table}"
  partitions=${table_partitions[$table]}
  # tasks_max=$(( partitions / 4 ))
  if [ "$partitions" -gt 12 ]; then
    tasks_max=$(( partitions / 2 ))
    batch_size=500000
  else
    tasks_max=$(( partitions / 4 ))
    batch_size=200000
  fi  
  output_file="./scripts/connector-templates/register-${table}.json"
  echo "🔧 Generating connector config for table: ${table} (tasks.max=${tasks_max})"
  cat > "$output_file" <<EOF
{
  "name": "${connector_name}",
  "config": {
    "connector.class": "io.debezium.connector.jdbc.JdbcSinkConnector",
    "tasks.max": "${tasks_max}",
    "batch.size": "${batch_size}",
    "topics": "${topic_name}",
    "connection.url": "${SINK_DB_URL}",
    "connection.username": "${USERNAME}",
    "connection.password": "${PASSWORD}",
    "insert.mode": "upsert",
    "delete.enabled": "true",
    "primary.key.mode": "record_key",
    "pk.mode": "kafka",
    "schema.evolution": "basic",
    "auto.create": "true",
    "auto.evolve": "true",
    "quote.identifiers": "true",
    "database.time_zone": "UTC",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true"
  }
}
EOF

  echo "📤 Registering connector: ${connector_name} with tasks.max=${tasks_max}"
  curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" "${CONNECT_URL}"  -d @"${output_file}"
#   curl -s -o /dev/null -w "→ HTTP %{http_code}\n" \
#     -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
#     "${CONNECT_URL}" \
#     -d @"${output_file}"

done

echo "✅ All connectors attempted."
