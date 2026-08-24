export DBUS_SESSION_BUS_ADDRESS="unix:path=/dev/null"
ZSH_THEME="h4Ck3r"
export ZSH=$HOME/.oh-my-zsh
plugins=(git zsh-autosuggestions fzf)

source $HOME/.oh-my-zsh/oh-my-zsh.sh
[[ -f /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Autosuggestions ──────────────────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888,bold"
bindkey '→' autosuggest-accept          # Right-arrow accepts suggestion
bindkey '^I' complete-word              # Tab for menu completion

# ── Enhanced Tab Completion ───────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select      # Arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completions
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
setopt AUTO_MENU           # Show menu on second Tab
setopt COMPLETE_IN_WORD    # Complete from cursor position
setopt ALWAYS_TO_END       # Move cursor to end after completion
setopt HIST_VERIFY         # Show command from history before running

