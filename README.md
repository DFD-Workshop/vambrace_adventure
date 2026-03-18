# 🤖 Vambrace Adventure

> *An open-source journey to build a teleoperation vambrace for ORION*
> *Una aventura open-source para construir un brazalete de teleoperación para ORION*

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![ROS 2 Jazzy](https://img.shields.io/badge/ROS_2-Jazzy-blue)](https://docs.ros.org/en/jazzy/)
[![Platform: ESP32](https://img.shields.io/badge/Platform-ESP32-green)](https://www.espressif.com/en/products/socs/esp32)

---

## 📖 What is Vambrace Adventure?

**Vambrace Adventure** (also known as **Brazalete de Teleoperación**) is a multidisciplinary robotics project that combines engineering, design, and storytelling. Our goal is to build a wearable teleoperation device (vambrace) that controls [ORION](https://github.com/DFD-Workshop/vambrace_adventure/wiki/the-team) — an open-source ROS 2 robot for Human-Robot Interaction (HRI).

This isn't just a technical project—it's an **adventure**. We're documenting every step of the journey through YouTube Shorts, detailed wiki episodes, and open-source code. Whether you're a robotics enthusiast, a student, or just curious about how robots work, you're invited to follow along and learn with us.

THIS REPOSITORY AND PROJECT IS STILL UNDER DEVELOPMENT, CHECK [PROJECT_STATUS](#-project-status) FOR MORE INFORMATION.

---

## 🎯 Project Goals

- 🕹️ **Build a teleoperation vambrace** using ESP32 and micro-ROS
- 🤖 **Control ORION wirelessly** through intuitive wearable inputs
- 📚 **Document the entire process** in an accessible, creative way
- 🌍 **Share knowledge openly** so others can build their own versions
- 🎨 **Combine technical depth with storytelling** as a new perspective

---

## 🗺️ The Journey So Far

We're documenting this adventure in episodic format. Check out the [**Wiki**](../../wiki) for detailed episodes!

| Episode | Title | Status | Video (EN) | Video (ES) |
| ------- | ----- | ------ | ---------- | ---------- |
| 0 | [The Idea](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-0-the-idea) | ✅ Complete | [Watch](https://youtube.com/shorts/ePQ3raQGBLI) | [Ver](https://youtube.com/shorts/H8rZN3Bph7M) |
| 1 | [The Journey](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-1-the-journey) | ✅ Complete | [Watch](https://youtube.com/shorts/TBTaS4n26_s) | [Ver](https://youtube.com/shorts/fl2nujOGEQM) |
| 2 | [The Comms](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-2-the-comms) | ✅ Complete | [Watch](https://youtube.com/shorts/PWvRbeZY11s) | [Ver](https://youtube.com/shorts/rVv_rLJkVis) |
| 3 | [The Tools](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-3-the-tools) | ✅ Complete | [Watch](https://youtube.com/shorts/s-ULhCpa5D4) | [Ver](https://youtube.com/shorts/_yhIwWnUc2I) |
| 4 | [The node](https://github.com/DFD-Workshop/vambrace_adventure/wiki/episode-4-the-node) | 🚧 In Progress | TBD | TBD |

---

## 🛠️ Tech Stack

### Hardware

- **ESP32** — Main micro-controller
- **Joystick** — Movement control
- **Potentiometers** — Arm position control
- **Membrane Keyboard** — Quick actions & emotions
- **LEDs & Buttons** — Feedback and additional controls

More details will be given as the adventure goes on.

### Software

- **Ubuntu 24.04 LTS** — Development OS
- **ROS 2 Jazzy** — Robotics middleware
- **micro-ROS** — Micro-controller-to-ROS2 bridge
- **PlatformIO** — Embedded development
- **Docker** — Environment containerization
- **VS Code** — Primary IDE

---

## 🚀 Getting Started

### Prerequisites

Before you begin, you'll need to set up your development environment. We've prepared a comprehensive installation guide:

📘 **[Installation Guide](docs/installation/README.md)**

This guide covers:

- Notes about Ubuntu 24.04 LTS installation
- ROS 2 Jazzy setup
- micro-ROS configuration
- PlatformIO and VS Code setup
- Docker installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/DFD-Workshop/vambrace_adventure.git
cd vambrace-adventure

# Follow the installation guide
cd docs/installation
cat README.md
```

> **Note:** We're still in the early stages! More code and documentation coming soon as we progress through the episodes.

---

## 📚 Documentation

- **[Wiki Home](https://github.com/DFD-Workshop/vambrace_adventure/wiki)** — Episode-by-episode documentation
- **[Installation Guide](/docs/installation/README.md)** — Complete setup instructions
- **[Meet the Team](https://github.com/DFD-Workshop/vambrace_adventure/wiki/the-team)** — Who we are
- **[Meet ORION](https://github.com/DFD-Workshop/vambrace_adventure/wiki/orion)** — Our robot companion

---

## 👥 The DFD Team

This project is brought to you by **DFD Team**:

- **Felipe** 🔧 — Engineer (Hardware & Software)
- **David** 🎨 — Designer (Visual Design & Creative Direction)
- **Danna** 📊 — Producer (Project & Content Strategy)

Together, we believe robotics should be **accessible**, **creative**, **open**, and most importantly, **fun**.

Learn more about us in the [Meet the Team](https://github.com/DFD-Workshop/vambrace_adventure/wiki/the-team) wiki page.

---

## 🤖 About ORION

**ORION** (Open-source Robot for Interaction Objectives and Navigation) is our ROS 2 Jazzy differential drive robot designed for HRI applications. The vambrace is being built specifically to control ORION in an intuitive, wearable way.

[Learn more about ORION →](https://github.com/DFD-Workshop/vambrace_adventure/wiki/orion)

---

## 🎥 Follow the Adventure

We're documenting this journey through bilingual YouTube Shorts (English & Spanish):

- 📺 **[YouTube Channel](https://www.youtube.com/@DFD_Workshop)** — Watch all episodes
- 📖 **[Wiki](https://github.com/DFD-Workshop/vambrace_adventure/wiki)** — Detailed episode breakdowns

---

## 🤝 Contributing

This is an **open-source adventure**, but contributions guidelines and notes on collaboration will be updated after completing the first stable version of the project.

---

## 📋 Project Status

### Current Phase: Episode 4 — In Development

**What's in development:**

- ✅ Episode 4 content and implementation
- ✅ Core ESP32 firmware development with µ-ROS
- ✅ Wiki notes on usage and micro-ROS explanation

**What's Next:**

- 🚧 Episode 5 content and implementation
- 🚧 Notes about joystick usage and integration
- 🚧  Considering demo of the project

---

## 📄 License

This project is licensed under the BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgments

- The **ROS 2 community** for incredible robotics tools.
- The **micro-ROS team** for bringing ROS to microcontrollers.
- The **ESP32 community** for extensive documentation and support.
- Everyone who follows along and supports this adventure!

---

## 💬 Stay Connected

- 💌 Email: [dfd_workshop@protonmail.com](dfd_workshop@protonmail.com)
- 📺 YouTube: [DFD Workshop](https://www.youtube.com/@DFD_Workshop)

---

<div align="center">

**Built with 💙 by DFD Team**

*Dream without limits. Create without fear.*

[🏠 Wiki Home](https://github.com/DFD-Workshop/vambrace_adventure/wiki) · [📺 Watch Episodes](https://www.youtube.com/watch?v=ePQ3raQGBLI&list=PLXoSBQg0DB-X-aZOT-QvVyyxHY4m7ZnkE) ·  [📺 Revisa los episodios](https://www.youtube.com/watch?v=ePQ3raQGBLI&list=PLXoSBQg0DB-X-aZOT-QvVyyxHY4m7ZnkE)

</div>
