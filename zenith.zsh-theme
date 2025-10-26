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

# Custom git prompt with traditional symbols
function custom_git_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null)

  # If not in git repo, just show directory
  if [[ -z $ref ]]; then
    local border="${gray}╭─${reset}"
    # Show expanded path if in home directory
    if [[ "$PWD" == "$HOME" ]]; then
      echo "${border} ${lightblue}~ ${gray}$HOME${reset}"
    else
      echo "${border} ${lightblue}%2~${reset}"
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
  echo "${border} ${lightblue}%2~${reset} ${git_status} ${magenta}${branch}${reset}"
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
