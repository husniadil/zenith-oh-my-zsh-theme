# github.com/husniadil/zenith-oh-my-zsh-theme

# Colors
local reset="%{$reset_color%}"
local gray="%{$FG[245]%}"
local lightblue="%{$FG[075]%}"
local cyan="%{$FG[081]%}"
local green="%{$FG[114]%}"
local yellow="%{$FG[221]%}"
local red="%{$FG[203]%}"
local magenta="%{$FG[213]%}"
local orange="%{$FG[208]%}"

# ZMX session indicator (https://github.com/neurosnap/zmx)
function zmx_indicator() {
  if [[ -n $ZMX_SESSION ]]; then
    echo "${orange}[zmx:${ZMX_SESSION}]${reset} "
  fi
}

# Virtualization environment indicator (PVE host, LXC container, VM)
# Priority: LXC_ID > PVE_VMID > PVE_HOST > auto-detect
# This order prevents inherited PVE_HOST from overriding LXC_ID in containers
function virt_indicator() {
  if [[ -n $LXC_ID ]]; then
    echo "${cyan}[LXC:${LXC_ID}]${reset} "
  elif [[ -n $PVE_VMID ]]; then
    echo "${cyan}[VM:${PVE_VMID}]${reset} "
  elif [[ -n $PVE_HOST ]]; then
    echo "${cyan}[PVE]${reset} "
  else
    # Auto-detect LXC container
    local container_env=$(cat /proc/1/environ 2>/dev/null | tr '\0' '\n' | grep '^container=' | cut -d= -f2)
    if [[ "$container_env" == "lxc" ]]; then
      echo "${cyan}[LXC]${reset} "
    # Auto-detect VM (KVM/QEMU)
    elif command -v systemd-detect-virt &>/dev/null; then
      local virt_type=$(systemd-detect-virt 2>/dev/null)
      if [[ "$virt_type" == "kvm" || "$virt_type" == "qemu" ]]; then
        echo "${cyan}[VM]${reset} "
      fi
    fi
  fi
}

# Terminal multiplexer indicator (tmux/screen/zellij/dvtm/abduco)
function mux_indicator() {
  if [[ -n $TMUX ]]; then
    local session_name=$(tmux display-message -p '#S' 2>/dev/null)
    if [[ -n $session_name ]]; then
      echo "${yellow}[tmux:${session_name}]${reset} "
    else
      echo "${yellow}[tmux]${reset} "
    fi
  elif [[ -n $STY ]]; then
    # STY format: pid.session_name.host - extract session name
    local session_name=${STY#*.}
    session_name=${session_name%%.*}
    if [[ -n $session_name ]]; then
      echo "${yellow}[screen:${session_name}]${reset} "
    else
      echo "${yellow}[screen]${reset} "
    fi
  elif [[ -n $ZELLIJ ]]; then
    # ZELLIJ contains session id, get name via zellij command
    local session_name=$(zellij list-sessions 2>/dev/null | grep CURRENT | awk '{print $1}')
    if [[ -n $session_name ]]; then
      echo "${yellow}[zellij:${session_name}]${reset} "
    else
      echo "${yellow}[zellij]${reset} "
    fi
  elif [[ -n $DVTM ]]; then
    echo "${yellow}[dvtm]${reset} "
  elif [[ -n $ABDUCO_SOCKET ]]; then
    # Extract session name from socket path
    local session_name=$(basename "$ABDUCO_SOCKET" 2>/dev/null)
    if [[ -n $session_name ]]; then
      echo "${yellow}[abduco:${session_name}]${reset} "
    else
      echo "${yellow}[abduco]${reset} "
    fi
  fi
}

# Hostname indicator (always visible)
function hostname_indicator() {
  echo "${green}@%m${reset} "
}

# Custom git prompt with traditional symbols
function custom_git_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null)

  # Session context indicators
  local zmx_prefix="$(zmx_indicator)"
  local virt_prefix="$(virt_indicator)"
  local mux_prefix="$(mux_indicator)"
  local host_prefix="$(hostname_indicator)"

  # If not in git repo, just show directory
  if [[ -z $ref ]]; then
    local border="${gray}╭─${reset}"
    # Show expanded path if in home directory
    if [[ "$PWD" == "$HOME" ]]; then
      echo "${border} ${host_prefix}${virt_prefix}${mux_prefix}${zmx_prefix}${lightblue}~ ${gray}$HOME${reset}"
    else
      echo "${border} ${host_prefix}${virt_prefix}${mux_prefix}${zmx_prefix}${lightblue}%2~${reset}"
    fi
    return 0
  fi

  local branch=${ref#refs/heads/}

  # Get git status
  local git_status=""
  local git_ahead=$(command git rev-list --count @{upstream}..HEAD 2>/dev/null)
  local git_behind=$(command git rev-list --count HEAD..@{upstream} 2>/dev/null)

  # Check for changes
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    # Dirty repository
    git_status="${yellow}✱${reset}"

    # Add specific status indicators
    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
      git_status="${git_status}${cyan}?${reset}"
    fi
    if [[ -n $(git diff --name-only --cached 2> /dev/null) ]]; then
      git_status="${git_status}${green}+${reset}"
    fi
    if [[ -n $(git diff --name-only 2> /dev/null) ]]; then
      git_status="${git_status}${yellow}~${reset}"
    fi
    if [[ -n $(git ls-files --deleted 2> /dev/null) ]]; then
      git_status="${git_status}${red}-${reset}"
    fi
    if [[ -n $(git diff --name-status --cached 2> /dev/null | grep '^R') ]]; then
      git_status="${git_status}${lightblue}»${reset}"
    fi
    if [[ -n $(git ls-files --unmerged 2> /dev/null) ]]; then
      git_status="${git_status}${red}═${reset}"
    fi
  else
    # Clean repository
    git_status="${green}✓${reset}"
  fi

  # Check for ahead/behind status
  if [[ -n $git_ahead && $git_ahead -gt 0 ]]; then
    git_status="${git_status}${cyan}↑${reset}"
  fi
  if [[ -n $git_behind && $git_behind -gt 0 ]]; then
    git_status="${git_status}${cyan}↓${reset}"
  fi

  # Add subtle top border
  local border="${gray}╭─${reset}"
  echo "${border} ${host_prefix}${virt_prefix}${mux_prefix}${zmx_prefix}${lightblue}%2~${reset} ${git_status} ${magenta}${branch}${reset}"
}

# Main prompt
PROMPT='$(custom_git_info)
%{$FG[245]%}╰─%{$reset_color%} %(?.%{$FG[081]%}❯.%{$FG[203]%}❯)%{$reset_color%} '

# Continuation prompt (multiline) - subtle vertical line
PS2="%{$FG[245]%}│ %{$reset_color%}"

# LS colors - optimized for dark terminals
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=1;34;46:cd=1;34;43:su=1;37;41:sg=1;37;46:tw=1;37;42:ow=1;37;43"

# Enable colors for ls, tree, etc.
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias tree="tree -C"

# Additional nice aliases
alias grep="grep --color=auto"
alias diff="diff --color=auto"
