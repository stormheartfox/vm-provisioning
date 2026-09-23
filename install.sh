#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/lib/common.sh"
require_root

SCRIPTS=(
  "00-desktop-environment.sh"
  "01-repos.sh"
  "02-packages.sh"
  "03-desktop.sh"
  "04-virtualbox.sh"
  "05-docker-neo4j.sh"
)

for script in "${SCRIPTS[@]}"; do
  log "Running ${script}"
  bash "${SCRIPT_DIR}/${script}"
done

log "Your shiny new VM is ready to rock and or roll - if this was from the Minimal ISO(and it should be!) - please reboot the machine now"