#!/bin/sh

set -e

echo "Syncing flow configuration..."

# IMPLEMENTME: flow init config -f config.yaml
os_name=$(uname)
if [ "$os_name" = "Darwin" ]; then
    dest_dir="$HOME/Library/Application Support/flow"
elif [ "$os_name" = "Linux" ]; then
    dest_dir="$HOME/.config/flow"
else
    echo "Unsupported operating system"
    exit 1
fi

if [ $SKIP_PROJECTS ]; then
  cp config-base.yaml "$dest_dir/config.yaml"
else
  cp config.yaml "$dest_dir/config.yaml"
fi