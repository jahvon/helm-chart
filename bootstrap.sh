#!/bin/sh

# f:verb=run f:name=system-bootstrap
# <f|description>
# Bootstrap a new machine in preparation to run executables for setting up dotfiles and tools.
# </f|description>

set -e

# Setup flow

if (command -v flow > /dev/null); then echo "Upgrading flow..."; else echo "Installing flow..."; fi
curl -sSL https://raw.githubusercontent.com/jahvon/flow/main/scripts/install.sh | bash

export INCLUDE_PROJECTS=${INCLUDE_PROJECTS:-"false"}
./cli/flow/install-workspaces.sh
./cli/flow/sync-config.sh
flow sync -x

# Install chezmoi and dotfiles

flow install chezmoi:cli -x
flow install completions -x

# Install zsh

if (command -v zsh > /dev/null); then
  echo "Zsh is already installed"
else
  echo "Installing Zsh..."
  if [ "$OS" = "darwin" ]; then
    brew install zsh
  else
    sudo apt-get install zsh
  fi
fi
