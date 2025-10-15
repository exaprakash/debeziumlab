ARG GRAFANA_VERSION
FROM grafana/grafana:${GRAFANA_VERSION}

COPY dashboard.yml /etc/grafana/provisioning/dashboards
COPY datasource.yml /etc/grafana/provisioning/datasources
COPY debezium-dashboard.json /var/lib/grafana/dashboards/debezium-dashboard.json
COPY brokers-dashboard.json /var/lib/grafana/dashboards/brokers-dashboard.json
COPY debezium-mysql-connector-dashboard.json /var/lib/grafana/dashboards/debezium-mysql-connector-dashboard.json
COPY prometheus_ds.yml /etc/grafana/provisioning/datasources
