#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script 06 — Full Environment Validation
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://docs.ros.org/en/jazzy/
#    https://micro.ros.org/docs/overview/
#    https://docs.platformio.org/
#    https://docs.docker.com/
#
#  ⚠️  IMPORTANT — READ BEFORE RUNNING:
#  This script only validates — it does not install anything.
#  It checks that every tool in the ORION stack is reachable and
#  reports a final pass/fail summary.
#
# =============================================================================

# ── Color helpers ─────────────────────────────────────────────────────────
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

PASS="PASS"
FAIL="FAIL"
WARN="WARN"

pass_count=0
fail_count=0
warn_count=0

# ── Result tracker ────────────────────────────────────────────────────────
result() {
    local status="$1"   # PASS | FAIL | WARN
    local label="$2"
    local detail="$3"

    if [[ "$status" == "PASS" ]]; then
        echo -e "  $PASS ${GREEN}${label}${RESET}  ${CYAN}${detail}${RESET}"
        ((pass_count++))
    elif [[ "$status" == "WARN" ]]; then
        echo -e "  $WARN ${YELLOW}${label}${RESET}  ${detail}"
        ((warn_count++))
    else
        echo -e "  $FAIL ${RED}${label}${RESET}  ${detail}"
        ((fail_count++))
    fi
}

# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         ORION Stack — Step 07: Environment Validation        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo " Checking all tools required to build and run ORION..."
echo ""

# ── 1. Operating System ───────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [1/6] Operating System"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$VERSION_ID" == "24.04" && "$ID" == "ubuntu" ]]; then
        result PASS "Ubuntu 24.04 LTS" "$PRETTY_NAME"
    else
        result WARN "OS mismatch" "Expected Ubuntu 24.04 — found: $PRETTY_NAME"
    fi
else
    result FAIL "OS undetectable" "/etc/os-release not found"
fi
echo ""

# ── 2. VS Code ────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [2/6] Visual Studio Code"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v code &>/dev/null; then
    VS_VER=$(code --version 2>/dev/null | head -1)
    result PASS "VS Code" "v$VS_VER"

    echo ""
    echo "  Checking recommended extensions..."
    EXTENSIONS=("ms-python.python" "ms-vscode.cpptools" "platformio.platformio-ide" "ms-vscode-remote.remote-containers")
    INSTALLED_EXT=$(code --list-extensions 2>/dev/null)
    for ext in "${EXTENSIONS[@]}"; do
        if echo "$INSTALLED_EXT" | grep -qi "$ext"; then
            result PASS "  Extension" "$ext"
        else
            result WARN "  Extension missing" "$ext"
        fi
    done
else
    result FAIL "VS Code not found" "Run: 01_vs_code_install.bash"
fi
echo ""

# ── 3. PlatformIO ─────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [3/6] PlatformIO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# Check both system PATH and common user install path
PIO_CMD=""
if command -v pio &>/dev/null; then
    PIO_CMD="pio"
elif [ -f "$HOME/.local/bin/pio" ]; then
    PIO_CMD="$HOME/.local/bin/pio"
fi

if [ -n "$PIO_CMD" ]; then
    PIO_VER=$($PIO_CMD --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
    result PASS "PlatformIO Core" "v$PIO_VER  ($PIO_CMD)"
else
    result WARN "PlatformIO CLI not found" "If installed via VS Code extension, this is expected — check inside VS Code"
fi
echo ""

# ── 4. ROS 2 Jazzy ────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [4/6] ROS 2 Jazzy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Source if not already sourced
if [ -z "$ROS_DISTRO" ] && [ -f /opt/ros/jazzy/setup.bash ]; then
    source /opt/ros/jazzy/setup.bash
fi

if [ -f /opt/ros/jazzy/setup.bash ]; then
    result PASS "ROS 2 Jazzy install" "/opt/ros/jazzy/setup.bash found"
else
    result FAIL "ROS 2 Jazzy not found" "Run: 04_ros2_jazzy_install.bash"
fi

if command -v ros2 &>/dev/null; then
    ROS_VER=$(ros2 --version 2>/dev/null | head -1)
    result PASS "ros2 CLI" "$ROS_VER"

    PKG_COUNT=$(ros2 pkg list 2>/dev/null | wc -l)
    result PASS "ROS 2 packages" "$PKG_COUNT packages available"
else
    result FAIL "ros2 CLI not in PATH" "Source ROS 2: source /opt/ros/jazzy/setup.bash"
fi

# Check .bashrc source line
if grep -qF "source /opt/ros/jazzy/setup.bash" ~/.bashrc; then
    result PASS ".bashrc auto-source" "ROS 2 will load in every new terminal"
else
    result WARN ".bashrc auto-source missing" "Add: echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc"
fi

# Check dev tools
for tool in colcon rosdep; do
    if command -v "$tool" &>/dev/null; then
        result PASS "  Tool: $tool" "$(command -v $tool)"
    else
        result WARN "  Tool missing: $tool" "Run: sudo apt install python3-${tool}"
    fi
done
echo ""

# ── 5. Docker ─────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [5/6] Docker Engine"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v docker &>/dev/null; then
    DOCKER_VER=$(docker --version 2>/dev/null)
    result PASS "Docker Engine" "$DOCKER_VER"

    # Test running without sudo
    if docker info &>/dev/null 2>&1; then
        result PASS "Docker (no sudo)" "Current user can run Docker"
    else
        result WARN "Docker requires sudo" "Run: sudo usermod -aG docker \$USER  then log out/in"
    fi

    # Docker Compose
    if docker compose version &>/dev/null 2>&1; then
        COMPOSE_VER=$(docker compose version 2>/dev/null)
        result PASS "Docker Compose" "$COMPOSE_VER"
    else
        result WARN "Docker Compose plugin missing" "Run: sudo apt install docker-compose-plugin"
    fi
else
    result FAIL "Docker not found" "Run: 05_docker.bash"
fi
echo ""

# ── 6. micro-ROS ──────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " [6/6] micro-ROS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Docker image
if command -v docker &>/dev/null; then
    if docker image inspect microros/micro-ros-agent:jazzy &>/dev/null 2>&1; then
        UROS_SIZE=$(docker image inspect microros/micro-ros-agent:jazzy \
            --format='{{.Size}}' 2>/dev/null | awk '{printf "%.0f MB", $1/1024/1024}')
        result PASS "micro-ROS Agent (Docker)" "Image present — $UROS_SIZE"
    else
        result WARN "micro-ROS Agent image not pulled" "Run: docker pull microros/micro-ros-agent:jazzy"
    fi
else
    result WARN "Cannot check Docker image" "Docker not available"
fi

# Check build-from-source workspace
UROS_WS="$HOME/microros_ws"
if [ -d "$UROS_WS/install" ]; then
    result PASS "micro-ROS workspace" "$UROS_WS/install found"
else
    result WARN "micro-ROS source workspace not found" "(optional if using Docker agent)"
fi

# Check serial port access
if ls /dev/ttyUSB* /dev/ttyACM* &>/dev/null 2>&1; then
    for port in $(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null); do
        result PASS "Serial port available" "$port"
    done
else
    result WARN "No serial ports detected" "Connect your microcontroller to see available ports"
fi
echo ""

# ── Final Summary ─────────────────────────────────────────────────────────
TOTAL=$((pass_count + fail_count + warn_count))
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     VALIDATION SUMMARY                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "  Total checks : $TOTAL"
echo -e "  ${GREEN}Passed        : $pass_count${RESET}"
echo -e "  ${YELLOW}Warnings      : $warn_count${RESET}"
echo -e "  ${RED}Failed        : $fail_count${RESET}"
echo ""

if [ "$fail_count" -eq 0 ] && [ "$warn_count" -eq 0 ]; then
    echo -e "  ${GREEN}ORION stack is fully operational. Ready to build!${RESET}"
elif [ "$fail_count" -eq 0 ]; then
    echo -e "  ${YELLOW}Stack is mostly ready. Review warnings above.${RESET}"
else
    echo -e "  ${RED}Some tools are missing. Run the corresponding install scripts.${RESET}"
    echo ""
    echo "  Install order:"
    echo "    01_vscode_install.bash → 02_platformio_install.bash"
    echo "    → 03_ros2_jazzy_install.bash → 04_docker_install.bash → 05_microros_install.bash"
fi
echo ""