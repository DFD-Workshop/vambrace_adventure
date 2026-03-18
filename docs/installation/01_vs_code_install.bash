#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script — Visual Studio Code
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://code.visualstudio.com/docs/setup/linux
#    https://packages.microsoft.com/repos/code
#
#  IMPORTANT — READ BEFORE RUNNING:
#  Microsoft occasionally updates GPG keys and repository URLs.
#  Always verify this installation method is still current at:
#    https://code.visualstudio.com/docs/setup/linux
#
# =============================================================================

set -e  # Exit immediately on error

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Installation — Step 01: Visual Studio Code           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VERIFY BEFORE PROCEEDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Repository URLs and GPG keys may change over time."
echo " Confirm this script is still valid before running:"
echo ""
echo "  Official Linux setup guide: https://code.visualstudio.com/docs/setup/linux"
echo "  Microsoft package repo:     https://packages.microsoft.com/repos/code"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -rp "  Have you verified the sources above? Continue? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "  Aborted. Please check the documentation first."
    exit 0
fi

echo ""
echo "  [1/4] Installing dependencies..."
sudo apt update && sudo apt install -y wget gpg

echo ""
echo "  [2/4] Adding Microsoft GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > /tmp/packages.microsoft.gpg

sudo install -D -o root -g root -m 644 \
    /tmp/packages.microsoft.gpg \
    /etc/apt/keyrings/packages.microsoft.gpg

rm /tmp/packages.microsoft.gpg

echo ""
echo "  [3/4] Adding VS Code repository..."
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

echo ""
echo "  [4/4] Installing Visual Studio Code..."
sudo apt update && sudo apt install -y code

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VS Code installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
code --version
echo ""
echo " Recommended extensions for ORION (install manually in VS Code):"
echo "   • ms-python.python"
echo "   • ms-vscode.cpptools"
echo "   • platformio.platformio-ide"
echo "   • ms-vscode-remote.remote-containers"
echo ""
echo " Next step → 02_platformio_install.sh"
echo ""