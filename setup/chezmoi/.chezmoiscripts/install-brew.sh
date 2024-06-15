#!/bin/bash

# f:verb=install f:named=brew
# f:alias=homebrew
# f:desc=Run brew bundle to install packages from Brewfile and update Homebrew

set -e

if (command -v brew > /dev/null); then
  echo "Homebrew is already installed"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing Homebrew packages..."
dir=$(dirname $0)
brew bundle --file="$dir/Brewfile"
echo "Updating Homebrew..."
brew update && brew upgrade
brew cleanup -s
