#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/config.sh"

require_root

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

install_aws_cli() {
  if command -v aws &>/dev/null; then
    CURRENT_VERSION=$(aws --version 2>&1 | awk -F/ '{print $2}' | awk '{print $1}')
    if [[ "${CURRENT_VERSION}" == "${AWS_CLI_VERSION}" ]]; then
      log "AWS CLI ${AWS_CLI_VERSION} already installed"
      return
    else
      warn "AWS CLI ${CURRENT_VERSION} installed, updating to ${AWS_CLI_VERSION}"
    fi
  fi

  log "Downloading AWS CLI v${AWS_CLI_VERSION}"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" \
    -o "${TMP_DIR}/awscliv2.zip"

  log "Extracting and running AWS CLI installer"
  unzip -q "${TMP_DIR}/awscliv2.zip" -d "${TMP_DIR}"

  if [[ -x /usr/local/bin/aws ]]; then
    "${TMP_DIR}/aws/install" --update
  else
    "${TMP_DIR}/aws/install"
  fi

  log "AWS CLI installed: $(aws --version)"
}

install_session_manager_plugin() {
  if command -v session-manager-plugin &>/dev/null; then
    log "Session Manager plugin already installed"
    return
  fi
  log "Installing AWS Session Manager plugin (required for 'aws ssm start-session')"
  curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" \
    -o "${TMP_DIR}/session-manager-plugin.rpm"
  dnf install -y "${TMP_DIR}/session-manager-plugin.rpm"
}

install_eksctl() {
  if command -v eksctl &>/dev/null; then
    log "eksctl already installed"
    return
  fi
  log "Installing eksctl"
  curl -fsSL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \
    -o "${TMP_DIR}/eksctl.tar.gz"
  tar -xzf "${TMP_DIR}/eksctl.tar.gz" -C "${TMP_DIR}"
  install -m 0755 "${TMP_DIR}/eksctl" /usr/local/bin/eksctl
}

install_aws_vault() {
  if command -v aws-vault &>/dev/null; then
    log "aws-vault already installed"
    return
  fi
  log "Installing aws-vault"
  curl -fsSL "https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64" \
    -o /usr/local/bin/aws-vault
  chmod 0755 /usr/local/bin/aws-vault
}

command -v unzip &>/dev/null || dnf install -y unzip

install_aws_cli

if [[ "${INSTALL_SESSION_MANAGER_PLUGIN}" == true ]]; then
  install_session_manager_plugin
fi

if [[ "${INSTALL_EKSCTL}" == true ]]; then
  install_eksctl
fi

if [[ "${INSTALL_AWS_VAULT}" == true ]]; then
  install_aws_vault
fi