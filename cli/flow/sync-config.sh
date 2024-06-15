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
    echo "Unsupported operating system ($os_name)"
    exit 1
fi


cur_dir=$(dirname $0)
# TODO: Make compatible with linux paths
if [ $INCLUDE_PROJECTS ]; then
  cp "$cur_dir/config.yaml" "$dest_dir/config.yaml"
else
  cp "$cur_dir/config-base.yaml" "$dest_dir/config.yaml"
fi