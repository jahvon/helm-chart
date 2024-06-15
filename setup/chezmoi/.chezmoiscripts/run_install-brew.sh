#!/bin/bash

# f:verb=install f:name=brew
# f:alias=homebrew
# f:desc=Run brew bundle to install packages from Brewfile and update Homebrew

set -e

if (command -v brew > /dev/null); then
  echo "Homebrew is already installed"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

dir=$(dirname $0)
brewfile="$dir/../Brewfile"
echo "Installing Homebrew packages ($brewfile)..."
brew bundle --file="$brewfile"
echo "Updating Homebrew..."
brew update && brew upgrade
brew cleanup -s
