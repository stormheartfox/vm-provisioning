#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

log "Installing EPEL release package ${EPEL_PACKAGE}"
dnf install -y "${EPEL_PACKAGE}"

log "Registering third-party repos"
for name in "${!REPOS[@]}"; do
  IFS='|' read -r baseurl gpgkey <<< "${REPOS[$name]}"
  repo_file="/etc/yum.repos.d/${name}.repo"

  if [[ -f "${repo_file}" ]]; then
    warn "Repo file ${repo_file} already exists, skipping creation"
  else
    log "Creating repo file for ${name}"
    cat > "${repo_file}" <<EOF
[${name}]
name=${name}
baseurl=${baseurl}
enabled=1
gpgcheck=1
gpgkey=${gpgkey}
EOF
  fi

  log "Importing GPG key for ${name}"
  rpm --import "${gpgkey}" || warn "Could not import key for ${name}, it may already be present"
done
log "Installing Microsoft prod repo config"
if rpm -q packages-microsoft-prod &>/dev/null; then
  log "Microsoft prod repo config already installed"
else
  dnf install -y "${MICROSOFT_PROD_CONFIG_RPM_URL}"
fi

log "Repo setup complete"