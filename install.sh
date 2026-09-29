#!/usr/bin/env bash

set -Eeuo pipefail

ENABLE_UFW=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [--enable-ufw]

Install Docker Engine and UFW on Ubuntu when they are not already installed.

Options:
  --enable-ufw  Allow OpenSSH, set safe defaults, and enable UFW.
  -h, --help    Show this help message.
EOF
}

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --enable-ufw)
      ENABLE_UFW=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      die "Unknown option: $arg"
      ;;
  esac
done

[[ -r /etc/os-release ]] || die "Cannot detect the operating system."
# shellcheck disable=SC1091
source /etc/os-release
[[ "${ID:-}" == "ubuntu" ]] || die "This script supports Ubuntu only."

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  die "Run this script as root or install sudo first."
fi

APT_UPDATED=false

apt_update_once() {
  if [[ "$APT_UPDATED" == false ]]; then
    log "Updating APT package index"
    "${SUDO[@]}" apt-get update
    APT_UPDATED=true
  fi
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    log "Docker is already installed: $(docker --version)"
  else
    log "Installing Docker Engine"
    apt_update_once
    "${SUDO[@]}" apt-get install -y ca-certificates curl

    "${SUDO[@]}" install -m 0755 -d /etc/apt/keyrings
    "${SUDO[@]}" curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      -o /etc/apt/keyrings/docker.asc
    "${SUDO[@]}" chmod a+r /etc/apt/keyrings/docker.asc

    local architecture
    architecture="$(dpkg --print-architecture)"
    printf '%s\n' \
      "deb [arch=${architecture} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
      | "${SUDO[@]}" tee /etc/apt/sources.list.d/docker.list >/dev/null

    # The Docker repository was just added, so its package index must be loaded.
    "${SUDO[@]}" apt-get update
    APT_UPDATED=true
    "${SUDO[@]}" apt-get install -y \
      docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  if command -v systemctl >/dev/null 2>&1; then
    "${SUDO[@]}" systemctl enable --now docker
  fi
}

install_ufw() {
  if command -v ufw >/dev/null 2>&1; then
    log "UFW is already installed"
  else
    log "Installing UFW"
    apt_update_once
    "${SUDO[@]}" apt-get install -y ufw
  fi

  if [[ "$ENABLE_UFW" == true ]]; then
    log "Configuring and enabling UFW"
    "${SUDO[@]}" ufw default deny incoming
    "${SUDO[@]}" ufw default allow outgoing
    "${SUDO[@]}" ufw allow OpenSSH
    "${SUDO[@]}" ufw --force enable
  else
    log "UFW was not enabled automatically"
    printf 'Run %s --enable-ufw when you are ready to enable it.\n' "$0"
  fi
}

install_docker
install_ufw

log "Installation check"
docker --version
"${SUDO[@]}" ufw status

log "Done"
