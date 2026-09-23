#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

log "Starting up docker --- please hold"
systemctl enable --now docker

log "Creating Neo4j data and log directories - this is a DB to ingest resource data from cloud environments. Queried via cyphershell"
mkdir -p "${NEO4J_DATA_DIR}" "${NEO4J_LOGS_DIR}"

COMPOSE_DIR="/opt/neo4j"
mkdir -p "${COMPOSE_DIR}"

cat > "${COMPOSE_DIR}/docker-compose.yml" <<EOF
services:
  neo4j:
    image: "${NEO4J_IMAGE}"
    container_name: "${NEO4J_CONTAINER_NAME}"
    restart: unless-stopped
    ports:
      - "${NEO4J_HTTP_PORT}:7474"
      - "${NEO4J_BOLT_PORT}:7687"
    volumes:
      - "${NEO4J_DATA_DIR}:/data"
      - "${NEO4J_LOGS_DIR}:/logs"
EOF

log "Starting Neo4j container via docker compose - look at Neo4J/Cyphershell docs to get started"
(cd "${COMPOSE_DIR}" && docker compose up -d)