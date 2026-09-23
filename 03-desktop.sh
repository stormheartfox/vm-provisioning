#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

GDM_CONF="/etc/gdm/custom.conf"

if [[ "${DISABLE_WAYLAND}" == true ]]; then
  if grep -q '^WaylandEnable=false' "${GDM_CONF}" 2>/dev/null; then
    log "Wayland already disabled in ${GDM_CONF}"
  else
    log "Disabling Wayland for display support - use View > Auto re-size Guest Display in VirtualBox to enable resizing of VM window"
    if grep -q '^\[daemon\]' "${GDM_CONF}" 2>/dev/null; then
      sed -i '/^\[daemon\]/a WaylandEnable=false' "${GDM_CONF}"
    else
      printf '\n[daemon]\nWaylandEnable=false\n' >> "${GDM_CONF}"
    fi
    warn "GDM config changed, run 'systemctl restart gdm' or reboot for this to take effect"
  fi
fi