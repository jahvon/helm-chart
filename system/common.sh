OS=$(uname -s | tr '[:upper:]' '[:lower:]')
CACHE_DIR="$HOME/.cache"
if [[ OS == "darwin" ]]; then
  CACHE_DIR="$HOME/Library/Caches"
else
  CACHE_DIR=$XDG_CONFIG_HOME
  if [[ -z $CACHE_DIR ]]; then CACHE_DIR=$HOME; fi
  CACHE_DIR="$CACHE_DIR/.cache"
fi
