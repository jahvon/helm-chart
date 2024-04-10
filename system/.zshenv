OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ OS == "darwin" ]]; then
  export CACHE_ROOT="$HOME/Library/Caches"
else
  CACHE_HOME=$XDG_CONFIG_HOME
  if [[ -z $CACHE_HOME ]]; then CACHE_HOME=$HOME; fi
  export CACHE_ROOT="$CACHE_HOME/.cache"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'

export DEV_ROOT="$HOME/Development"
export NOTES_ROOT="$HOME/Notes"
export DOWNLOADS_ROOT="$HOME/Downloads"
export LABS_ROOT="$DEV_ROOT/labs"
export APPS_ROOT="$DEV_ROOT/apps"
export TOOLS_ROOT="$DEV_ROOT/tools"
export OSS_ROOT="$DEV_ROOT/oss"
export FLOW_WS_ROOT="$DEV_ROOT/workspaces"

[[ -f ~/.flowkey ]] && export FLOW_VAULT_KEY=$(cat ~/.flowkey)

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
