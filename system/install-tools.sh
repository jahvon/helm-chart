#!/bin/bash

source common.sh

set -e

if (command -v brew > /dev/null); then
  echo "Homebrew is already installed"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "Installing Homebrew packages..."
brew bundle --file=./Brewfile
echo "Updating Homebrew..."
brew update && brew upgrade
brew cleanup -s

if (command -v zsh > /dev/null); then
  echo "Zsh is already installed"
else
  echo "Installing Zsh..."
  if [ "$OS" = "darwin" ]; then
    brew install zsh
  else
    sudo apt-get install zsh
  fi

  echo "Installing oh-my-zsh..."
  ZSH=$HOME/.oh-my-zsh; sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Installing zsh plugins and themes..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi
chsh -s $(which zsh)
./source-shell.sh

if (command -v flow > /dev/null); then echo "Upgrading flow..."; else echo "Installing flow..."; fi
curl -sSL https://raw.githubusercontent.com/jahvon/flow/main/scripts/install.sh | bash
flow completion zsh > $HOME/.oh-my-zsh/completions/_flow

if [[ -f $GOBIN/g ]]; then
  goversion=$(go version | awk '{print $3}')
  echo "go version manager (g) is already installed (go version: $goversion)"
else
  echo "Installing go version manager (g)..."
  curl -sSL https://git.io/g-install | sh -s -- -y
  $GOBIN/g install latest
fi
