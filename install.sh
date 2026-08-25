#!/usr/bin/env bash
# ============================================================
#  Termux & Linux Enhanced Shell Installer — by deepu2135
#  GitHub: https://github.com/deepu2135/termux-setup
# ============================================================

set -e

# ANSI Color Output
BOLD='\033[1m'
CYAN='\033[38;5;51m'
GREEN='\033[38;5;46m'
YELLOW='\033[38;5;226m'
MAGENTA='\033[38;5;201m'
RED='\033[38;5;196m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()   { echo -e "${RED}[ERR]${RESET} $1"; exit 1; }

echo -e "${MAGENTA}${BOLD}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║      Enhanced Terminal Setup by @deepu2135           ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Detect Package Manager & Install Dependencies ─────────
info "Detecting system environment and package manager..."

if command -v pkg &>/dev/null; then
  info "Termux environment detected (using pkg)..."
  pkg update -y
  pkg install -y zsh starship fastfetch fzf bat eza zoxide git curl
elif command -v apt-get &>/dev/null; then
  info "Debian/Ubuntu/PRoot environment detected (using apt)..."
  if [ "$(id -u)" -eq 0 ]; then
    DEBIAN_FRONTEND=noninteractive apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales zsh starship fastfetch fzf bat eza zoxide zsh-autosuggestions zsh-syntax-highlighting git curl fonts-jetbrains-mono
  else
    sudo apt-get update -y
    sudo apt-get install -y locales zsh starship fastfetch fzf bat eza zoxide zsh-autosuggestions zsh-syntax-highlighting git curl fonts-jetbrains-mono
  fi
else
  warn "Unknown package manager. Please ensure starship, fastfetch, zsh, fzf, bat, eza, and zoxide are installed."
fi

# ── 2. Create Destination Directories ────────────────────────
info "Preparing configuration directories..."
mkdir -p "$HOME/.config/fastfetch" \
         "$HOME/.config/bat" \
         "$HOME/.termux/bin" \
         "$HOME/.termux/colors"

# ── 3. Back Up Existing Dotfiles ─────────────────────────────
backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    cp "$file" "${file}.bak"
    warn "Backed up $(basename "$file") → $(basename "$file").bak"
  fi
}

backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.config/starship.toml"

# ── 4. Copy Configurations ───────────────────────────────────
info "Deploying modern dotfiles..."
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
cp "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
cp "$SCRIPT_DIR/config/starship.toml" "$HOME/.config/starship.toml"
cp "$SCRIPT_DIR/config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
cp "$SCRIPT_DIR/config/bat/config" "$HOME/.config/bat/config"

# ── 5. Copy Termux Helper Tools & Color Schemes ──────────────
info "Installing color themes & theme switcher..."
cp "$SCRIPT_DIR/termux/termux.properties" "$HOME/.termux/termux.properties" 2>/dev/null || true
cp -r "$SCRIPT_DIR/termux/colors/"* "$HOME/.termux/colors/"
cp -r "$SCRIPT_DIR/termux/bin/"* "$HOME/.termux/bin/"
chmod +x "$HOME/.termux/bin/"*

# Global symlink for theme switcher if root
if [ "$(id -u)" -eq 0 ]; then
  ln -sf "$HOME/.termux/bin/termux-theme" /usr/local/bin/termux-theme 2>/dev/null || true
  ln -sf "$HOME/.termux/bin/termux-theme" /usr/local/bin/theme 2>/dev/null || true
fi

# Apply default Catppuccin Mocha theme
if [ -f "$HOME/.termux/colors/catppuccin-mocha.properties" ]; then
  cp "$HOME/.termux/colors/catppuccin-mocha.properties" "$HOME/.termux/colors.properties"
fi

# Reload Termux settings if supported
if command -v termux-reload-settings &>/dev/null; then
  termux-reload-settings 2>/dev/null || true
fi

# ── 6. Default Shell Setup ───────────────────────────────────
if command -v zsh &>/dev/null; then
  chsh -s zsh 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}${BOLD}✔ Installation finished successfully!${RESET}"
echo -e "${CYAN}  • Start a new shell or run: ${YELLOW}exec zsh${RESET}"
echo -e "${CYAN}  • Switch themes anytime with: ${YELLOW}theme${RESET}"
echo -e "${CYAN}  • View storage & system dashboard with: ${YELLOW}fetch${RESET}"
echo ""
