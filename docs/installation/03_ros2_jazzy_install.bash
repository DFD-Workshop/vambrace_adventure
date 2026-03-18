#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script — ROS 2 Jazzy Jalisco
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
#    https://www.ros.org/reps/rep-0003.html  (Platform targets per distro)
#
#  IMPORTANT — READ BEFORE RUNNING:
#  ROS 2 repository keys and package names change between distributions.
#  Always verify this script against the official installation page:
#    https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
#
# =============================================================================

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                 Installation — ROS 2 Jazzy Jalisco           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VERIFY BEFORE PROCEEDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " ROS 2 repository keys and package structure are updated regularly."
echo " Always confirm this script is still valid at:"
echo ""
echo "  Official install guide:  https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html"
echo "  Platform targets (REP-3): https://www.ros.org/reps/rep-0003.html"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$VERSION_ID" != "24.04" || "$ID" != "ubuntu" ]]; then
        echo " WARNING: This script is designed for Ubuntu 24.04."
        echo "    Detected: $PRETTY_NAME"
        read -rp "    Continue anyway? [y/N]: " force
        [[ "$force" =~ ^[Yy]$ ]] || exit 0
    else
        echo " Ubuntu 24.04 detected — compatible with ROS 2 Jazzy."
    fi
fi

echo ""
read -rp "  Have you verified the sources above? Continue? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "  Aborted."; exit 0; }

echo ""
echo "  [1/5] Setting up locale..."
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo ""
echo "  [2/5] Adding ROS 2 GPG key and repository..."
sudo apt install -y software-properties-common curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo ""
echo "  [3/5] Installing ROS 2 Jazzy Desktop (full)..."
sudo apt update
sudo apt install -y ros-jazzy-desktop

echo ""
echo "  [4/5] Installing development tools..."
sudo apt install -y \
    python3-colcon-common-extensions \
    python3-rosdep \
    ros-dev-tools

echo ""
echo "  [5/5] Initializing rosdep..."
sudo rosdep init 2>/dev/null || echo "  (rosdep already initialized — skipping)"
rosdep update

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " ROS 2 Jazzy installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Source setup
SOURCE_LINE="source /opt/ros/jazzy/setup.bash"
if ! grep -qF "$SOURCE_LINE" ~/.bashrc; then
    echo "$SOURCE_LINE" >> ~/.bashrc
    echo "  ROS 2 environment added to ~/.bashrc"
else
    echo "  ROS 2 environment already in ~/.bashrc"
fi

source /opt/ros/jazzy/setup.bash

echo ""
echo " Verify with the classic talker/listener demo:"
echo "   Terminal 1: ros2 run demo_nodes_cpp talker"
echo "   Terminal 2: ros2 run demo_nodes_py listener"
echo ""
echo " Next step → 04_docker_install.bash"
echo ""