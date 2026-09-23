#!/usr/bin/env bash
set -euo pipefail

log() {
  echo -e "\e[1;32m[+] $*\e[0m"
}

warn() {
  echo -e "\e[1;33m[!] $*\e[0m"
}

err() {
  echo -e "\e[1;31m[x] $*\e[0m" >&2
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    err "==== This script must be run as root or with sudo. Re-run as: sudo $0 ===="
    exit 1
  fi
}

mark_reboot_required() {
  touch /tmp/.vm_provisioning_reboot_required
  warn "A reboot will be required after provisioning completes for this change to take effect"
}