#!/usr/bin/env bash

curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-srcmysql.json
# curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-sinkmysql.json

# Connection to Kafka Connect REST
CONNECT_URL="http://localhost:8083/connectors/"
# Sink DB connection
SINK_DB_URL="jdbc:mysql://sinkmysql:3306/tpcc"
USERNAME="mysqluser"
PASSWORD="mysqlpw"
# Table → Partition count mapping
declare -A table_partitions=(
  ["warehouse"]=4
  ["district"]=8
  ["customer"]=24
  ["history"]=12
  ["orders"]=24
  ["new_order"]=12
  ["order_line"]=24
  ["item"]=4
  ["stock"]=24
)
rm -fr ./scripts/connector-templates
mkdir -p ./scripts/connector-templates

# Generate and register connector per table
for table in "${!table_partitions[@]}"; do
  connector_name="sink_mysql_${table}"
  topic_name="cdc.tpcc.${table}"
  partitions=${table_partitions[$table]}
  tasks_max=$(( partitions / 4 ))
  output_file="./scripts/connector-templates/register-${table}.json"
  echo "🔧 Generating connector config for table: ${table} (tasks.max=${tasks_max})"
  cat > "$output_file" <<EOF
{
  "name": "${connector_name}",
  "config": {
    "connector.class": "io.debezium.connector.jdbc.JdbcSinkConnector",
    "tasks.max": "${tasks_max}",
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
