[ -x "$HOME/.termux/bin/apply-active-palette" ] && "$HOME/.termux/bin/apply-active-palette" 2>/dev/null
# ~/.bashrc: executed by bash(1) for non-login shells.

# Auto-start Zsh if running interactively
if [ -t 1 ] && [ -z "$ZSH_VERSION" ] && [ -x "$(command -v zsh)" ]; then
  exec zsh
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && [ -z "$PROMPT_COMMAND" ] && return

# History configuration
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Bat theme & Term environment
export BAT_THEME="Catppuccin Mocha"
export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"
export PATH="/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/home/.termux/bin:/data/data/com.termux/files/home/.local/bin:/usr/local/bin:/root/.local/bin:/root/.termux/bin:$HOME/.local/bin:$HOME/.termux/bin:$PATH"

# Antigravity CLI
[ -x "/root/.local/bin/agy" ] && alias agy="/root/.local/bin/agy"

# ── Modern Aliases ───────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --git --group-directories-first --time-style=relative'
  alias la='eza -a --icons --group-directories-first'
  alias l='eza -lh --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons --group-directories-first'
  alias tree='eza --tree --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -laF --color=auto'
  alias la='ls -A --color=auto'
  alias l='ls -CF --color=auto'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --style=plain --paging=never'
  alias preview='bat --style=numbers --color=always'
elif command -v batcat &>/dev/null; then
  alias cat='batcat --style=plain --paging=never'
  alias preview='batcat --style=numbers --color=always'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias cls='clear'
alias q='exit'

alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'

alias fetch='fastfetch'
alias theme='termux-theme'
alias myip='echo -n "Public IP: " && curl -s https://api.ipify.org && echo "" && echo "Local IP:" && (ifconfig 2>/dev/null | grep -E "inet [0-9.]+" || ip a | grep inet)'
alias ports='ss -tulpn 2>/dev/null || netstat -tulanp 2>/dev/null || lsof -i'

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"        ;;
      *.tar.gz)    tar xzf "$1"        ;;
      *.bz2)       bunzip2 "$1"        ;;
      *.rar)       unrar x "$1"        ;;
      *.gz)        gunzip "$1"         ;;
      *.tar)       tar xf "$1"         ;;
      *.tbz2)      tar xjf "$1"        ;;
      *.tgz)       tar xzf "$1"        ;;
      *.zip)       unzip "$1"          ;;
      *.Z)         uncompress "$1"     ;;
      *.7z)        7z x "$1"           ;;
      *.tar.xz)    tar xf "$1"         ;;
      *.tar.zst)   tar --zstd -xf "$1" ;;
      *)           echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

cheat() {
  curl -s "cheat.sh/${1}"
}

weather() {
  curl -s "wttr.in/${1:-}?m"
}

bak() {
  cp -r "$1" "${1}.bak" && echo "✔ Backed up $1 → ${1}.bak"
}

# Starship Prompt in Bash
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

if [[ -o interactive ]]; then
  if command -v fastfetch &>/dev/null; then
    fastfetch
  fi
fi
