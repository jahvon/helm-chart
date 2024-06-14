#!/bin/bash

# f:verb=install f:named=fonts
# f:desc=Install Karla and MonoLisa fonts


source common.sh

set -e

echo "Installing fonts..."
tffFiles=$(find fonts -type f -name "*.ttf")
if [[ $OS == "darwin" ]]; then
  for file in $tffFiles; do
    cp "$file" ~/Library/Fonts
  done
else
  for file in $tffFiles; do
    cp "$file" ~/.local/share/fonts
  done
  fc-cache -
fi