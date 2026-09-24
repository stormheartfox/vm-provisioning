#!/usr/bin/env bash

# This is simply some of the repos I used - if you want to add others, put them in this list - they may be useful!
declare -A REPOS=(
  [docker-ce-stable]="https://download.docker.com/linux/centos/\$releasever/\$basearch/stable|https://download.docker.com/linux/centos/gpg"
  [code]="https://packages.microsoft.com/yumrepos/vscode|https://packages.microsoft.com/keys/microsoft.asc"
  [microsoft-edge]="https://packages.microsoft.com/yumrepos/edge-stable|https://packages.microsoft.com/keys/microsoft.asc"
  [trivy]="https://aquasecurity.github.io/trivy-repo/rpm/releases/x86_64/|https://aquasecurity.github.io/trivy-repo/rpm/public.key"
)

MICROSOFT_PROD_CONFIG_RPM_URL="https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm"
EPEL_PACKAGE="epel-release"

DEV_TOOLCHAIN_PACKAGES=(gcc make perl kernel-devel kernel-headers elfutils-libelf-devel)
CONTAINER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
PROGRAMMING_LANGUAGE_PACKAGES=(java-21-openjdk python3 python3-pip python3-devel openssl-devel golang)
APP_PACKAGES=(code azure-cli microsoft-edge-stable zsh git gh graphviz trivy powershell)

DISABLE_WAYLAND=true
DESKTOP_GROUP="Workstation"

VBOX_GUEST_ADDITIONS_VERSION="7.2.16"

NEO4J_IMAGE="neo4j:2025.07.1"
NEO4J_CONTAINER_NAME="neo4j"
NEO4J_HTTP_PORT=7474
NEO4J_BOLT_PORT=7687
NEO4J_DATA_DIR="/opt/neo4j/data"
NEO4J_LOGS_DIR="/opt/neo4j/logs"

# AWS SECTION -  for sanity and security AWS version is pinned - update as needed
AWS_CLI_VERSION="2.27.41"

# These are optional values - look up if you need them if you're not sure
INSTALL_SESSION_MANAGER_PLUGIN=true
INSTALL_EKSCTL=false
INSTALL_AWS_VAULT=false