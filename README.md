# Vambrace_Adventure

## About

Welcome to a new adventure from the DFD Team. Here we aim to develop a Mandalorian-like Vambrace to teloperate ORION actions like platform movement, arms position, emotion display, and predefined behaviors. Hope you enjoy this!

[DFD Workshop](https://www.youtube.com/@DFD_Workshop)

## Table of content

- [License](#license)
- [Process and documentation](#process-and-documentation)

  - [Why to do it? (Chapter 1 | The idea)](#why-to-do-it-chapter-1--the-idea)
  - [The plan (Chapter 2 | The journey)](#the-plan-chapter-2--the-journey)
  - [Installation and requirements (Chapter 3 | The tools)](#installation-and-requirements-chapter-3--the-tools)

- dd

## License

## Process and documentation

### Why to do it? (Chapter 1 | The idea)

### The plan (Chapter 2 | The journey)

### Installation and requirements (Chapter 3 | The tools)

#### Ubuntu 24.04 LTS

Ubuntu 24.04 "Noble Numbat" is the base operating system for ORION's stack. It is the recommended distribution for ROS 2 Jazzy, as it is its primary supported platform.

| Method | When to use it |
|---|---|
| **Native installation** | Dedicated robot hardware or main development PC |
| **Virtual machine (VirtualBox/VMware)** | Quick testing for software on local setup without risks |
| **WSL2 (Windows)** | Windows development with access to Linux tooling on a local environment |
| **Dual boot** | Full hardware access without giving up your main operating system |

We recommend the next resources for installation:

- 📺 [Install Ubuntu 24.04 from scratch (YouTube)](https://www.youtube.com/results?search_query=install+ubuntu+24.04+tutorial)
- 📺 [Ubuntu 24.04 on VirtualBox (YouTube)](https://www.youtube.com/results?search_query=ubuntu+24.04+virtualbox+tutorial+english)
- 📖 [Official Ubuntu documentation](https://ubuntu.com/tutorials/install-ubuntu-desktop)


#### Visual Studio Code

VS Code is the primary editor for ORION development. Through its extensions, it covers both microcontroller firmware and ROS 2 node development in a single environment.

### Installation on Ubuntu 24.04

```bash
# Download and install from the official Microsoft repository
sudo apt update && sudo apt install -y wget gpg

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
  https://packages.microsoft.com/repos/code stable main" | \
  sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

sudo apt update && sudo apt install -y code
```

Once VS Code is installed, search and install these extensions from the Marketplace (`Ctrl+Shift+X`):

| Extension | Purpose |
|---|---|
| `ms-python.python` | ROS 2 node development in Python |
| `ms-vscode.cpptools` | C++ development for ROS 2 and firmware |
| `platformio.platformio-ide` | Microcontroller firmware management |
| `ms-vscode-remote.remote-containers` | Docker container integration |
| `redhat.vscode-yaml` | ROS 2 configuration file editing |

---

#### PlatformIO

PlatformIO is the development ecosystem for ORION's microcontroller firmware. It integrates directly as a VS Code extension.

PlatformIO is installed as a VS Code extension:

1. Open VS Code
2. Go to Extensions (`Ctrl+Shift+X`)
3. Search for **PlatformIO IDE**
4. Click **Install**

PlatformIO will automatically install its core (PlatformIO Core) and all required dependencies on first use.

Once installed, verify the environment is working correctly:

```bash
# Verify PlatformIO Core from the terminal
pio --version

# Expected output:
# PlatformIO Core, version X.X.X
```

#### ROS 2 Jazzy Jalisco

ROS 2 Jazzy is ORION's core middleware for node communication, navigation, and HRI applications. It is the LTS version compatible with Ubuntu 24.04.


```bash
# 1. Set up locale
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2. Add the ROS 2 repository
sudo apt install -y software-properties-common curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
  -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
  http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 3. Install ROS 2 Jazzy (full Desktop)
sudo apt update && sudo apt upgrade -y
sudo apt install -y ros-jazzy-desktop

# 4. Install development tools
sudo apt install -y python3-colcon-common-extensions python3-rosdep ros-dev-tools

# 5. Initialize rosdep
sudo rosdep init
rosdep update
```


```bash
# Add the source to .bashrc so it's available in every terminal session
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
source ~/.bashrc
```


```bash
# Verify the installation with the classic demo
# Terminal 1 — Publisher:
ros2 run demo_nodes_cpp talker

# Terminal 2 — Subscriber:
ros2 run demo_nodes_py listener
```

If you see messages like `[INFO] [talker]: Publishing: 'Hello World: X'`, ROS 2 Jazzy is up and running!

---

#### Docker Engine

Docker allows containerizing ORION's development and deployment environment, ensuring reproducibility across different development machines.

### Installation

```bash
# 1. Remove old versions (if any)
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null

# 2. Install dependencies
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Add the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Post-installation setup

```bash
# Allow running Docker without sudo
sudo groupadd docker 2>/dev/null
sudo usermod -aG docker $USER

# Apply group changes (or restart your session)
newgrp docker
```

### Verification

```bash
docker run hello-world
# Expected output: "Hello from Docker!"

docker --version
docker compose version
```

---

#### micro-ROS

micro-ROS extends the ROS 2 ecosystem to resource-constrained microcontrollers, enabling ORION's low-level hardware to communicate directly with ROS 2 Jazzy nodes.

### ORION architecture

```
[ Microcontroller (PlatformIO + micro-ROS client) ]
            ↕  (Serial / UDP)
[ micro-ROS Agent (Ubuntu / Docker) ]
            ↕  (DDS)
[ ROS 2 Jazzy Nodes ]
```

### Option A — micro-ROS Agent via Docker (recommended)

The cleanest way to run the agent without polluting the base installation:

```bash
# Pull and run the micro-ROS agent (adjust the serial port)
docker run -it --rm \
  --net=host \
  --device=/dev/ttyUSB0 \
  microros/micro-ros-agent:jazzy \
  serial --dev /dev/ttyUSB0 -b 115200
```

> 💡 Replace `/dev/ttyUSB0` with the serial port where your microcontroller is connected. Use `ls /dev/tty*` to identify it.

### Option B — Build from source in the ROS 2 workspace

```bash
# 1. Create the micro-ROS workspace
mkdir -p ~/microros_ws/src && cd ~/microros_ws

# 2. Clone the setup tools package
git clone -b jazzy https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup

# 3. Install dependencies and build
source /opt/ros/jazzy/setup.bash
sudo apt update && rosdep update
rosdep install --from-paths src --ignore-src -y
colcon build --symlink-install
source install/local_setup.bash

# 4. Create and build the agent
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
source install/local_setup.bash

# 5. Run the agent
ros2 run micro_ros_agent micro_ros_agent serial --dev /dev/ttyUSB0 -b 115200
```

### PlatformIO integration

Add the micro-ROS library to your `platformio.ini`:

```ini
[env:orion_mcu]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200

lib_deps =
  https://github.com/micro-ROS/micro_ros_arduino.git
```

### Verification

With the agent running and the microcontroller connected, open another terminal:

```bash
source /opt/ros/jazzy/setup.bash
ros2 topic list
# You should see the topics published by the microcontroller
```

---

## 7. Full Environment Verification

Once all steps are completed, use this checklist to confirm the full stack is operational:

```bash
# Operating System
lsb_release -a                          # Ubuntu 24.04 Noble

# VS Code
code --version

# PlatformIO
pio --version

# ROS 2 Jazzy
source /opt/ros/jazzy/setup.bash
ros2 --version                          # ros2cli 0.x (Jazzy)
ros2 pkg list | grep -c ""              # number of installed packages

# Docker
docker --version
docker compose version
docker run hello-world

# micro-ROS Agent (Docker)
docker pull microros/micro-ros-agent:jazzy && echo "Image available ✓"
```

---

## References & Additional Resources

| Resource | URL |
|---|---|
| ROS 2 Jazzy documentation | https://docs.ros.org/en/jazzy/ |
| micro-ROS documentation | https://micro.ros.org/docs/overview/ |
| PlatformIO documentation | https://docs.platformio.org/ |
| Docker get started | https://docs.docker.com/get-started/ |
| Ubuntu 24.04 release notes | https://ubuntu.com/blog/ubuntu-desktop-24-04-noble-numbat-deep-dive |

---

> **DFD Team** — Felipe · David · Danna
> *Building ORION, one commit at a time.* 🤖