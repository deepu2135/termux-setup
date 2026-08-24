#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  Termux Setup Installer — by deepu2135
#  Installs oh-my-zsh, zsh plugins, fzf and dotfiles
# ============================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()   { echo -e "${RED}[ERR]${RESET} $1"; exit 1; }

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║     Termux Setup by deepu2135        ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"

# ── 1. Update packages ───────────────────────────────────
info "Updating packages..."
pkg update -y && pkg upgrade -y

# ── 2. Install dependencies ──────────────────────────────
info "Installing zsh, git, curl, fzf, figlet, lolcat..."
pkg install -y zsh git curl fzf figlet ruby
gem install lolcat 2>/dev/null || warn "lolcat install failed (optional)"

# ── 3. Install oh-my-zsh ────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  warn "oh-my-zsh already installed, skipping."
fi

# ── 4. Install zsh-autosuggestions ──────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
else
  warn "zsh-autosuggestions already installed, skipping."
fi

# ── 5. Install zsh-syntax-highlighting ──────────────────
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"
else
  warn "zsh-syntax-highlighting already installed, skipping."
fi

# ── 6. Copy dotfiles ─────────────────────────────────────
info "Copying .zshrc..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
  warn "Backed up existing .zshrc → .zshrc.bak"
fi
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# ── 7. Set zsh as default shell ──────────────────────────
info "Setting zsh as default shell..."
chsh -s zsh 2>/dev/null || warn "Could not set zsh as default (run 'chsh -s zsh' manually)"

echo ""
success "✅ Installation complete!"
echo -e "${CYAN}  → Open a new Termux session or run: ${YELLOW}source ~/.zshrc${RESET}"
echo ""
