#!/bin/sh
echo "⏳ Waiting for Kafka to be ready..."
while ! nc -z kafka 9092; do sleep 1; done
echo "✅ Kafka is ready. Creating topics..."

declare -A topics_partitions=(
  ["cdc.tpcc.warehouse"]=4
  ["cdc.tpcc.district"]=8
  ["cdc.tpcc.customer"]=24
  ["cdc.tpcc.history"]=12
  ["cdc.tpcc.orders"]=24
  ["cdc.tpcc.new_order"]=12
  ["cdc.tpcc.order_line"]=24
  ["cdc.tpcc.item"]=4
  ["cdc.tpcc.stock"]=24
)

for topic in "${!topics_partitions[@]}"
do
  partitions=${topics_partitions[$topic]}
  echo "Creating topic $topic with $partitions partitions..."
  /usr/bin/kafka-topics --create \
    --if-not-exists \
    --topic "$topic" \
    --bootstrap-server kafka:9092 \
    --replication-factor 1 \
    --partitions "$partitions"
done

echo "✅ All topics created."
