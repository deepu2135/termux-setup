# 🖥️ Termux Setup — by deepu2135

A clean, minimal Termux shell configuration with smart autocompletion, fuzzy history search, and syntax highlighting.

## ✨ Features

| Feature | Description |
|---|---|
| 🔮 **Ghost-text autosuggestions** | Suggests commands as you type (press `→` to accept) |
| 🔍 **Fuzzy history search** | Press `Ctrl+R` to fuzzy-search all past commands |
| 🎨 **Syntax highlighting** | Commands turn green when valid, red when invalid |
| 📁 **Tab completion menu** | Navigate completions with arrow keys |
| 🔡 **Case-insensitive tab** | `git com` + Tab matches `git commit` |

## 📦 What's Included

```
termux-setup/
├── .zshrc        # Main shell config (oh-my-zsh + plugins + completion)
└── install.sh    # One-command auto-installer
```

## 🚀 Quick Install

```bash
# Clone the repo
git clone https://github.com/deepu2135/termux-setup
cd termux-setup

# Run installer
bash install.sh
```

Then **open a new Termux session** — everything will be ready.

## ⌨️ Keybindings

| Key | Action |
|---|---|
| `→` (Right Arrow) | Accept the current ghost suggestion |
| `Tab` | Open completion menu |
| `Ctrl+R` | Fuzzy search command history |
| Arrow keys | Navigate the completion menu |

## 🛠️ Stack

- **Shell**: [Zsh](https://www.zsh.org/)
- **Framework**: [oh-my-zsh](https://ohmyz.sh/)
- **Suggestions**: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- **Highlighting**: [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- **Fuzzy Search**: [fzf](https://github.com/junegunn/fzf)

---

> Made with ❤️ by [@deepu2135](https://github.com/deepu2135)
