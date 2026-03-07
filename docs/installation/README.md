# Installation Guides and Notes

## Installation Scripts for ORION's Software Stack

> **Series:** DFD Workshop - Vambrace Adventure
> **Episode wiki:** [Episode 3 — The Tools](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-3-the-tools)
> **Stack:** Ubuntu 24.04 · VS Code · PlatformIO · ROS 2 Jazzy · Docker · micro-ROS

---

## ⚠️ Read This First

> **These scripts are provided as-is, for educational and reference purposes.**
> By running any of these scripts you accept full responsibility for any changes made to your system. DFD Workshop does not guarantee these scripts will work on every machine, configuration, or future version of the tools involved. Always back up your system before running installation scripts from any source.
>
> Installation procedures for third-party tools (VS Code, ROS 2, Docker, micro-ROS) change over time. **Before running any script, verify it against the official documentation** — each script includes the relevant source links at the top of the file.

---

## 📖 Read the Wiki First

Before running anything, we strongly recommend reading the full episode documentation:

### 👉 [Episode 3 — The Tools (Wiki)](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-3-the-tools)

The wiki covers the reasoning behind each tool choice, the architecture of ORION's software stack, and the context you need to understand what each script is actually doing. The scripts here are a companion to that documentation, not a replacement for it.

---

## ✅ Tested Environment

These scripts were developed and validated on a **clean Ubuntu 24.04 LTS** environment using **Multipass** — a lightweight VM manager by Canonical. Every script in this repository was run in sequence on a fresh VM before being published.

| Item | Details |
| -- | --- |
| OS | Ubuntu 24.04 LTS (Noble Numbat) |
| Test environment | Multipass VM (2 vCPUs, 4 GB RAM, 30 GB disk) |
| Host OS during testing | Ubuntu 24.04 |
| ROS 2 distro | Jazzy Jalisco |

> ⚠️ Serial port checks (`/dev/ttyUSB0`) will show a warning in the validator — this is expected in any VM environment without physical USB passthrough. It is not a failure.

---

## 📂 Scripts

Run these in order on a clean Ubuntu 24.04 installation.

| # | Script | What it installs |
| - | - | - |
| 01 | `01_vs_code_install.bash` | Visual Studio Code + recommended extensions |
| 02 | `02_platformio_install.bash` | PlatformIO Core (via pipx, Ubuntu 24.04 compatible) |
| 03 | `03_ros2_jazzy_install.bash` | ROS 2 Jazzy Jalisco + dev tools + rosdep |
| 04 | `04_docker_install.bash` | Docker Engine + Compose plugin + post-install setup |
| 05 | `05_microros_install.bash` | micro-ROS Agent (Docker image or build from source) |
| 06 | `06_validate_installation.bash` | Validates the full stack — no installs, read-only checks |

### Usage

~~~bash
# Clone the repository
git clone https://github.com/DFD-Workshop/vambrace_adventure.git
cd vambrace_adventure/tools/installation

# Make scripts executable
chmod +x *.bash

# Run in order
bash 01_vs_code_install.bash
bash 02_platformio_install.bash
bash 03_ros2_jazzy_install.bash
bash 04_docker_install.bash
bash 05_microros_install.bash

# Validate the full stack
bash 06_validate_installation.bash
~~~

Each script will print its official documentation sources and ask for confirmation before making any changes to your system.

---

## 🧪 Testing with Multipass (Recommended)

If you want to test these scripts without risking your main machine, we recommend using **Multipass** — the same tool used to validate this repository.

### What is Multipass?

Multipass is a lightweight VM manager by Canonical that spins up real Ubuntu VMs in seconds. It uses native hypervisors (KVM on Linux, HyperKit on macOS, Hyper-V on Windows) and requires no complex configuration.

**Official site:** [Multipass](https://multipass.run)
**Documentation:** [Multipass Docs](https://multipass.run/docs)

### Install Multipass

#### Ubuntu / Linux

~~~bash
sudo snap install multipass
~~~

##### macOS

~~~bash
brew install --cask multipass
~~~

**Windows** — download the installer from [MultiPass Installer](https://multipass.run/install)

### Launch a test VM

~~~bash
# Create a clean Ubuntu 24.04 VM
multipass launch 24.04 \
  --name orion-test \
  --cpus 2 \
  --memory 4G \
  --disk 30G

# Open a shell inside it
multipass shell orion-test
~~~

### Transfer the scripts into the VM

~~~bash
# Mount this folder into the VM
multipass mount /path/to/installation orion-test:/home/ubuntu/orion_scripts

# Then inside the VM:
cd ~/orion_scripts
chmod +x *.bash
~~~

### Snapshot strategy (highly recommended)

Take a snapshot after each successful step. If a later script fails, you can restore to the last known good state without starting over.

~~~bash
# From your HOST machine — stop VM, snapshot, restart
multipass stop orion-test
multipass snapshot orion-test --name after-vscode
multipass start orion-test
~~~

To restore a snapshot:

~~~bash
multipass stop orion-test
multipass restore orion-test.after-vscode
multipass start orion-test
~~~

### Clean up when done

~~~bash
# From your host machine
multipass stop orion-test
multipass delete orion-test
multipass purge

# Uninstall Multipass (optional)
sudo snap remove multipass          # Linux
brew uninstall --cask multipass     # macOS
~~~

---

## 🔗 Official Documentation Sources

| Tool | Documentation |
| - | - |
| Ubuntu 24.04 | [Ubuntu Docs](https://ubuntu.com/tutorials/install-ubuntu-desktop) |
| Visual Studio Code | [VS Code Docs(https://code.visualstudio.com/docs/setup/linux) |
| PlatformIO | [PlatformIO Docs](https://docs.platformio.org/en/latest/core/installation/index.html) |
| ROS 2 Jazzy | [ROS 2 Docs](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html) |
| Docker Engine | [Docker Docs](https://docs.docker.com/engine/install/ubuntu/) |
| micro-ROS | [micro-ROS Docs](https://micro.ros.org/docs/tutorials/core/first_application_linux/) |
| Multipass | [MultiPass Docs](https://multipass.run/docs) |

---

## 🤖 About ORION

ORION (Open-source Robot for Interaction Objectives and Navigation) is a ROS 2 Jazzy differential robot built by DFD Team for Human-Robot Interaction research and content creation. This repository is part of the **Vambrace Adventure** series, documenting the development of a µ-ROS teleoperation wristband for ORION built on ESP32.

Follow the full build series on the [Vambrace Adventure Wiki](https://github.com/DFD-Workshop/vambrace_adventure/wiki).

---

> **DFD Workshop** — Felipe · David · Danna
> *Building this project, one commit at a time.*
