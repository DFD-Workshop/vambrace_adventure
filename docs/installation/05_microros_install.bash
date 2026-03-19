#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script  — micro-ROS
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://micro.ros.org/docs/tutorials/core/first_application_linux/
#    https://github.com/micro-ROS/micro_ros_setup
#    https://github.com/micro-ROS/micro_ros_arduino  (PlatformIO integration)
#
#  ⚠️  IMPORTANT — READ BEFORE RUNNING:
#  micro-ROS is actively developed and branches/package names change often.
#  Always verify the correct branch for your ROS 2 distro (jazzy) at:
#    https://github.com/micro-ROS/micro_ros_setup/branches
#  Also check the Docker agent image tags at:
#    https://hub.docker.com/r/microros/micro-ros-agent/tags
#
# =============================================================================

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                Installation —  micro-ROS                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VERIFY BEFORE PROCEEDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " micro-ROS is actively developed — branches and APIs change often."
echo " Always confirm this script is still valid at:"
echo ""
echo "  micro-ROS first app guide:    https://micro.ros.org/docs/tutorials/core/first_application_linux/"
echo "  micro_ros_setup (GitHub):     https://github.com/micro-ROS/micro_ros_setup"
echo "  Docker agent image tags:      https://hub.docker.com/r/microros/micro-ros-agent/tags"
echo "  PlatformIO integration:       https://github.com/micro-ROS/micro_ros_arduino"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo " Choose your micro-ROS Agent installation method:"
echo ""
echo "  [A] Docker (recommended — isolated, no build required)"
echo "  [B] Build from source in a ROS 2 workspace"
echo ""
read -rp "  Choose method [A/b]: " method
method="${method:-A}"

# ── Shared: serial port check ─────────────────────────────────────────────
echo ""
echo " Available serial ports (for your microcontroller):"
ls /dev/tty* 2>/dev/null | grep -E "USB|ACM" || echo "  (no USB/ACM serial devices found — connect your board first)"
echo ""
read -rp "  Enter your serial port [default: /dev/ttyUSB0]: " SERIAL_PORT
SERIAL_PORT="${SERIAL_PORT:-/dev/ttyUSB0}"
echo "  Using port: $SERIAL_PORT"

echo ""

if [[ "$method" =~ ^[Bb]$ ]]; then
    # ── Option B: Build from source ─────────────────────────────────────
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Option B — Building micro-ROS Agent from source"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Check ROS 2 is sourced
    if [ -z "$ROS_DISTRO" ]; then
        if [ -f /opt/ros/jazzy/setup.bash ]; then
            source /opt/ros/jazzy/setup.bash
            echo "  ROS 2 Jazzy sourced."
        else
            echo " ROS 2 Jazzy not found. Please run 03_ros2_jazzy_install.bash first."
            exit 1
        fi
    else
        echo "  ROS 2 distro detected: $ROS_DISTRO"
    fi

    echo ""
    echo "  [1/5] Creating micro-ROS workspace..."
    MICROROS_WS="$HOME/microros_ws"
    mkdir -p "$MICROROS_WS/src"
    cd "$MICROROS_WS"

    echo ""
    echo "  [2/5] Cloning micro_ros_setup (branch: jazzy)..."
    if [ -d "src/micro_ros_setup" ]; then
        echo "  (micro_ros_setup already cloned — pulling latest)"
        git -C src/micro_ros_setup pull
    else
        git clone -b jazzy \
            https://github.com/micro-ROS/micro_ros_setup.git \
            src/micro_ros_setup
    fi

    echo ""
    echo "  [3/5] Installing dependencies and building..."
    sudo apt update && rosdep update
    rosdep install --from-paths src --ignore-src -y
    colcon build --symlink-install
    source install/local_setup.bash

    echo ""
    echo "  [4/5] Creating and building the micro-ROS Agent workspace..."
    ros2 run micro_ros_setup create_agent_ws.sh
    ros2 run micro_ros_setup build_agent.sh
    source install/local_setup.bash

    echo "  [5/5] Created and built the micro-ROS Agent workspace..."

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ micro-ROS Agent built from source!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo " To run the agent:"
    echo "   cd $MICROROS_WS"
    echo "   source install/local_setup.bash"
    echo "   ros2 run micro_ros_agent micro_ros_agent serial --dev $SERIAL_PORT -b 115200"

else
    # ── Option A: Docker ──────────────────────────────────────────────────
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Option A — micro-ROS Agent via Docker"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ! command -v docker &>/dev/null; then
        echo " Docker not found. Please run 04_docker_install.bash first."
        exit 1
    fi

    echo ""
    echo "  Pulling micro-ROS Agent image (jazzy)..."
    docker pull microros/micro-ros-agent:jazzy

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " micro-ROS Agent image ready!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo " Run the agent with:"
    echo ""
    echo "   docker run -it --rm \\"
    echo "     --net=host \\"
    echo "     --device=$SERIAL_PORT \\"
    echo "     microros/micro-ros-agent:jazzy \\"
    echo "     serial --dev $SERIAL_PORT -b 115200"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " PlatformIO — lib_deps entry for your platformio.ini:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   lib_deps ="
echo "     https://github.com/micro-ROS/micro_ros_arduino.git"
echo ""
echo " Verify the microcontroller once the agent is running:"
echo "   source /opt/ros/jazzy/setup.bash"
echo "   ros2 topic list"
echo ""
echo " ORION software stack setup complete!"
echo ""