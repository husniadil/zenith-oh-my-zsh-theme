# Define color variables for the prompt
local reset="%{$reset_color%}"
local gray="%{$FG[245]%}"
local lightblue="%{$FG[075]%}"
local cyan="%{$FG[081]%}"
local green="%{$FG[114]%}"
local yellow="%{$FG[221]%}"
local red="%{$FG[203]%}"
local magenta="%{$FG[213]%}"

# Git prompt configuration
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX="${reset}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="${green}✓${reset}"
ZSH_THEME_GIT_PROMPT_ADDED="${green}+${reset}"
ZSH_THEME_GIT_PROMPT_MODIFIED="${yellow}~${reset}"
ZSH_THEME_GIT_PROMPT_DELETED="${red}-${reset}"
ZSH_THEME_GIT_PROMPT_RENAMED="${lightblue}»${reset}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${red}═${reset}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${cyan}?${reset}"
ZSH_THEME_GIT_PROMPT_AHEAD="${cyan}↑${reset}"
ZSH_THEME_GIT_PROMPT_BEHIND="${cyan}↓${reset}"

# Custom git prompt function that shows git status and branch
function custom_git_prompt() {
  local git_status="$(git_prompt_status)"
  if [ -n "$git_status" ]; then
    echo "${git_status} $(git_current_branch)"
  else
    echo "$(git_prompt_info) $(git_current_branch)"
  fi
}

# Record start time when a command begins execution
function preexec() {
  timer=${timer:-$SECONDS}
}

# Display execution time for commands that take longer than 3 seconds
function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 3 ]; then
      export RPROMPT="${gray}${timer_show}s ${reset}"
    else
      export RPROMPT=""
    fi
    unset timer
  fi
}

# Define prompt symbol (shows ❯ in cyan if last command succeeded, red if failed)
local prompt_symbol() {
  echo -n "%(?.${cyan}❯.${red}❯)${reset} "
}

# Show current directory (last 2 components of path)
local directory_info="${lightblue}%2~${reset}"

# Set the main prompt format
PROMPT='${directory_info}$(git_prompt_info) $(git_current_branch)
$(prompt_symbol)'

# Configure colors for ls commands
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=1;34;46:cd=1;34;43:su=1;37;41:sg=1;37;46:tw=1;37;42:ow=1;37;43"

# Set up colorized aliases for common commands
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias tree="tree -C"

alias grep="grep --color=auto"
alias diff="diff --color=auto"
