#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

log "Starting up docker --- please hold"
systemctl enable --now docker

TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo "")}"

if [[ -n "${TARGET_USER}" ]]; then
  if id -nG "${TARGET_USER}" | grep -qw docker; then
    log "${TARGET_USER} is already a member of the docker group"
  else
    log "Adding ${TARGET_USER} to the docker group"
    usermod -aG docker "${TARGET_USER}"
    mark_reboot_required
    warn "${TARGET_USER} was added to the docker group. Reboot using \e[1msudo reboot\e[0m for docker commands work without sudo. Alternatively \e[1mnewgrp docker\e[0m will allow command execution before reboot occurs"
  fi
else
  warn "Could not determine find user. Add your user to docker group manually: \e[1msudo usermod -aG docker <username>\e[0m"
fi

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