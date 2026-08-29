#!/usr/bin/env bash
# ============================================================
#  Termux Welcome Banner & System Status — by deepu2135
# ============================================================

# ANSI color codes
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_CYAN="\033[38;5;51m"
C_GREEN="\033[38;5;46m"
C_YELLOW="\033[38;5;226m"
C_BLUE="\033[38;5;75m"
C_MAGENTA="\033[38;5;201m"
C_RED="\033[38;5;196m"
C_GRAY="\033[38;5;242m"
C_WHITE="\033[38;5;255m"

# Fetch system details quickly
SYS_USER="${USER:-$(whoami)}"
SYS_HOST="${HOSTNAME:-$(uname -n 2>/dev/null || echo "localhost")}"
SYS_OS="$(uname -o 2>/dev/null || echo "Android/Linux")"
SYS_ARCH="$(uname -m 2>/dev/null || echo "arm64")"
SYS_KERNEL="$(uname -r 2>/dev/null | cut -d'-' -f1)"

# Uptime
if [ -f /proc/uptime ]; then
  uptime_sec=$(cut -d. -f1 /proc/uptime)
  up_days=$((uptime_sec / 86400))
  up_hours=$(((uptime_sec % 86400) / 3600))
  up_mins=$(((uptime_sec % 3600) / 60))
  if [ $up_days -gt 0 ]; then
    SYS_UPTIME="${up_days}d ${up_hours}h ${up_mins}m"
  elif [ $up_hours -gt 0 ]; then
    SYS_UPTIME="${up_hours}h ${up_mins}m"
  else
    SYS_UPTIME="${up_mins}m"
  fi
else
  SYS_UPTIME="unknown"
fi

# RAM usage
if [ -f /proc/meminfo ]; then
  mem_total=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
  mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print int($2/1024)}')
  if [ -n "$mem_total" ] && [ -n "$mem_avail" ]; then
    mem_used=$((mem_total - mem_avail))
    SYS_RAM="${mem_used}MB / ${mem_total}MB"
  else
    SYS_RAM="$(free -m 2>/dev/null | awk '/Mem:/ {print $3"MB / "$2"MB"}')"
  fi
else
  SYS_RAM="unknown"
fi

# Storage usage in $HOME
SYS_DISK="$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $3" / "$2" ("$5")"}')"

# Battery status (with timeout to prevent hanging if termux-api service is inactive)
SYS_BATTERY=""
if command -v termux-battery-status &>/dev/null; then
  bat_json=$(timeout 0.3 termux-battery-status 2>/dev/null)
  if [ -n "$bat_json" ]; then
    percentage=$(echo "$bat_json" | grep -o '"percentage": [0-9]*' | cut -d: -f2 | tr -d ' ')
    status=$(echo "$bat_json" | grep -o '"status": "[^"]*"' | cut -d: -f2 | tr -d ' "')
    if [ -n "$percentage" ]; then
      SYS_BATTERY="${percentage}% (${status})"
    fi
  fi
fi

if [ -z "$SYS_BATTERY" ] && [ -d /sys/class/power_supply/battery ]; then
  cap="$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)"
  stat="$(cat /sys/class/power_supply/battery/status 2>/dev/null)"
  [ -n "$cap" ] && SYS_BATTERY="${cap}% (${stat})"
fi

# Output Banner
echo -e "${C_CYAN}  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗${C_RESET}"
echo -e "${C_CYAN}  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝${C_RESET}"
echo -e "${C_BLUE}     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ ${C_RESET}"
echo -e "${C_BLUE}     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ ${C_RESET}"
echo -e "${C_MAGENTA}     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗${C_RESET}"
echo -e "${C_MAGENTA}     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝${C_RESET}"
echo -e "${C_GRAY}        ── Enhanced Shell Experience by @deepu2135 ──${C_RESET}"
echo ""
echo -e "  ${C_CYAN}● User:${C_RESET}     ${C_WHITE}${SYS_USER}@${SYS_HOST}${C_RESET}    ${C_CYAN}● OS:${C_RESET}      ${C_WHITE}${SYS_OS} (${SYS_ARCH})${C_RESET}"
echo -e "  ${C_BLUE}● Kernel:${C_RESET}   ${C_WHITE}${SYS_KERNEL}${C_RESET}              ${C_BLUE}● Uptime:${C_RESET}  ${C_WHITE}${SYS_UPTIME}${C_RESET}"
echo -e "  ${C_GREEN}● Memory:${C_RESET}   ${C_WHITE}${SYS_RAM}${C_RESET}       ${C_GREEN}● Storage:${C_RESET} ${C_WHITE}${SYS_DISK}${C_RESET}"
if [ -n "$SYS_BATTERY" ]; then
echo -e "  ${C_YELLOW}● Battery:${C_RESET}  ${C_WHITE}${SYS_BATTERY}${C_RESET}"
fi
echo -e "  ${C_GRAY}────────────────────────────────────────────────────────${C_RESET}"
echo -e "  ${C_GRAY}Type ${C_YELLOW}termux-theme${C_GRAY} to change colors | ${C_YELLOW}Ctrl+R${C_GRAY} for fuzzy search${C_RESET}"
echo ""
