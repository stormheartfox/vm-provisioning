#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

CURRENT_TARGET=$(systemctl get-default)

if dnf group list installed 2>/dev/null | grep -q "${DESKTOP_GROUP}"; then
  log "${DESKTOP_GROUP} group already installed"
else
  log "Minimal install detected (current boot target: ${CURRENT_TARGET}). Installing ${DESKTOP_GROUP} group, this will take a while"
  dnf groupinstall -y "${DESKTOP_GROUP}"
fi

if [[ "${CURRENT_TARGET}" != "graphical.target" ]]; then
  log "Setting default boot target to graphical"
  systemctl set-default graphical.target
  mark_reboot_required
fi