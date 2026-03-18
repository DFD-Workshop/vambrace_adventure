#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script — Docker Engine
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://docs.docker.com/engine/install/ubuntu/
#    https://docs.docker.com/engine/install/linux-postinstall/
#
#  IMPORTANT — READ BEFORE RUNNING:
#  Docker's GPG key URL and repository structure are updated periodically.
#  Always verify this script against the current official guide before running:
#    https://docs.docker.com/engine/install/ubuntu/
#
# =============================================================================

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                Installation  — Docker Engine                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VERIFY BEFORE PROCEEDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Docker's install instructions change with each major release."
echo " Always confirm this script is still valid at:"
echo ""
echo "  Docker Engine install (Ubuntu): https://docs.docker.com/engine/install/ubuntu/"
echo "  Post-install steps:             https://docs.docker.com/engine/install/linux-postinstall/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -rp "  Have you verified the sources above? Continue? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "  Aborted."; exit 0; }

echo ""
echo "  [1/5] Removing old Docker versions (if any)..."
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null \
    || echo "  (no old versions found — continuing)"

echo ""
echo "  [2/5] Installing dependencies..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo ""
echo "  [3/5] Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo ""
echo "  [4/5] Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ""
echo "  [5/5] Installing Docker Engine..."
sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Docker Engine installed! Configuring post-install steps..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Post-install: allow running without sudo
sudo groupadd docker 2>/dev/null || echo "  (docker group already exists)"
sudo usermod -aG docker "$USER"
echo "  User '$USER' added to 'docker' group."
echo ""
echo "      You must log out and back in (or run 'newgrp docker')"
echo "      for the group change to take effect."
echo ""

echo "  Verifying Docker installation..."
sudo docker run --rm hello-world

echo ""
docker --version
docker compose version
echo ""
echo " Next step → 05_microros_install.sh"
echo ""