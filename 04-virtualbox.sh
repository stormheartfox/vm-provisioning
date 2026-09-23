#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

VIRT_TYPE=$(systemd-detect-virt || true)

if [[ "${VIRT_TYPE}" == "oracle" ]]; then
  log "VirtualBox detected - for quality of life, Guest Additions services is being activated"
  for svc in vboxadd vboxadd-service vgauthd; do
    if systemctl list-unit-files "${svc}.service" &>/dev/null; then
      systemctl enable --now "${svc}"
    else
      warn "${svc}.service not found, Guest Additions may not be installed yet"
    fi
  done

  if [[ -d "/opt/VBoxGuestAdditions-${VBOX_GUEST_ADDITIONS_VERSION}" ]]; then
    log "VirtualBox Guest Additions found at expected version"
  else
    warn "Guest Additions not found. Install them via the hypervisor menu: Devices > Insert Guest Additions CD Image"
  fi
else
  log "Non-VirtualBox environment detected (${VIRT_TYPE:-unknown}), skipping VirtualBox-specific setup steps"
fi