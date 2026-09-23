#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

# Necessary for doing basically anything on a linux box - and with some repos using Make
log "Installing development toolchain packages"
dnf install -y "${DEV_TOOLCHAIN_PACKAGES[@]}"

# If you dont plan on using containers comment this out
log "Installing container runtime packages"
dnf install -y "${CONTAINER_PACKAGES[@]}"

# check the config.sh and you can add or remove the packages you want in your environment I have simply added
# ones that I used in particular!
log "Installing language and runtime packages(SDKs and all that jazz) - be aware that Rocky Linux default golang may be older than what you require"
dnf install -y "${PROGRAMMING_LANGUAGE_PACKAGES[@]}"

# Having edge helps for corporate tools and powershell installs is helpful for diffing Azure infra
log "Installing application and CLI packages - including Microsoft Edge and Powershell"
dnf install -y "${APP_PACKAGES[@]}"

log "Package installation complete"