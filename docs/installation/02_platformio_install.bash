#!/usr/bin/env bash
# =============================================================================
#  ORION — Chapter 3: The Tools
#  Script 02 — PlatformIO
# =============================================================================
#
#  SOURCE / OFFICIAL DOCUMENTATION:
#    https://docs.platformio.org/en/latest/integration/ide/vscode.html
#    https://docs.platformio.org/en/latest/core/installation/index.html
#
#  IMPORTANT — READ BEFORE RUNNING:
#  PlatformIO is primarily installed as a VS Code extension (recommended).
#  The CLI can also be installed standalone. Ubuntu 24.04 enforces PEP 668,
#  which blocks plain `pip3 install --user` — this script uses pipx instead,
#  which manages an isolated venv per tool and is the Ubuntu-recommended approach.
#  Verify the current installation method at:
#    https://docs.platformio.org/en/latest/core/installation/index.html
#    https://peps.python.org/pep-0668/  (why pip3 --user no longer works on 24.04)
#
# =============================================================================

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                 Installation — PlatformIO                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " VERIFY BEFORE PROCEEDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " PlatformIO installation methods may change between versions."
echo " Always confirm this script is still valid at:"
echo ""
echo "  VS Code extension guide: https://docs.platformio.org/en/latest/integration/ide/vscode.html"
echo "  PlatformIO Core (CLI):   https://docs.platformio.org/en/latest/core/installation/index.html"
echo "  PEP 668 (why pipx):      https://peps.python.org/pep-0668/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo " PlatformIO can be installed in two ways:"
echo ""
echo "  [A] As a VS Code extension (recommended — GUI + full IDE)"
echo "  [B] As a standalone CLI via pipx (Ubuntu 24.04 compatible)"
echo ""
read -rp "  Choose installation method [A/b]: " method
method="${method:-A}"

if [[ "$method" =~ ^[Bb]$ ]]; then
    # ── CLI via pipx ───────────────────────────────────────────────
    # Ubuntu 24.04 enforces PEP 668 — plain `pip3 install --user` is
    # blocked to protect the system Python environment. pipx solves this
    # by creating an isolated venv per application, which is exactly
    # what Ubuntu now recommends for CLI tools like PlatformIO.
    echo ""
    echo "  [1/3] Installing pipx and python3-venv..."
    sudo apt update && sudo apt install -y pipx python3-venv
    pipx ensurepath

    echo ""
    echo "  [2/3] Installing PlatformIO Core via pipx..."
    pipx install platformio

    echo ""
    echo "  [3/3] Ensuring pipx bin directory is in PATH..."
    EXPORT_LINE='export PATH="$HOME/.local/bin:$PATH"'
    if ! grep -qF "$EXPORT_LINE" ~/.bashrc; then
        echo "$EXPORT_LINE" >> ~/.bashrc
        echo "  PATH updated in ~/.bashrc"
    else
        echo "  PATH already set in ~/.bashrc"
    fi
    export PATH="$HOME/.local/bin:$PATH"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " ✅ PlatformIO Core installed via pipx!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    pio --version

else
    # ── VS Code extension ─────────────────────────────────────────
    echo ""
    echo "  Installing PlatformIO IDE extension in VS Code..."

    if command -v code &>/dev/null; then
        code --install-extension platformio.platformio-ide
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo " ✅ PlatformIO IDE extension installed in VS Code!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo " Restart VS Code to activate the extension."
    else
        echo " VS Code (code) not found in PATH."
        echo " Please run 01_vs_code_install.bash first, then re-run this script."
        exit 1
    fi
fi

echo ""
echo " ORION platformio.ini reference config:"
echo ""
echo "   [env:orion_mcu]"
echo "   platform = espressif32"
echo "   board = esp32dev"
echo "   framework = arduino"
echo "   monitor_speed = 115200"
echo ""
echo " Next step → 03_ros2_jazzy_install.bash"
echo ""