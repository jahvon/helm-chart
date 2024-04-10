#!/bin/bash

set -e

echo "Backing up dotfiles..."
BACKUP_DIR=~/backup
mkdir -p $BACKUP_DIR
[[ -f ~/.zshrc ]] && cp ~/.zshrc $BACKUP_DIR/.zshrc.bak
[[ -f ~/.zprofile ]] && cp ~/.zprofile $BACKUP_DIR/.zprofile.bak
[[ -f ~/.zshenv ]] && cp ~/.zshenv $BACKUP_DIR/.zshenv.bak
[[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh $BACKUP_DIR/.p10k.zsh.bak
[[ -f ~/.gitconfig ]] && cp ~/.gitconfig $BACKUP_DIR/.gitconfig.bak
[[ -f ~/.gitignore_global ]] && cp ~/.gitignore_global $BACKUP_DIR/.gitignore_global.bak
[[ -f ~/.gitmessage ]] && cp ~/.gitmessage $BACKUP_DIR/.gitmessage.bak

echo "Copying dotfiles..."
cp .zshrc ~/.zshrc > /dev/null
cp .zprofile ~/.zprofile > /dev/null
cp .zshenv ~/.zshenv > /dev/null
cp .p10k.zsh ~/.p10k.zsh > /dev/null
cp .gitconfig ~/.gitconfig > /dev/null
cp .gitignore_global ~/.gitignore_global > /dev/null
cp .gitmessage ~/.gitmessage > /dev/null

echo "Creating local dotfiles..."
[[ -f ~/.zshrc.local ]] || touch ~/.zshrc.local
[[ -f ~/.zshenv.local ]] || touch ~/.zshenv.local
[[ -f ~/.gitconfig.local ]] || touch ~/.gitconfig.local

GIT_NAME="${GIT_NAME:=Jahvon Dockery}"
GIT_EMAIL="${GIT_EMAIL:=email@jahvon.dev}"
GITHUB_USER="${GITHUB_USER:=jahvon}"
echo "Setting up git for $GIT_USER ($GIT_EMAIL)..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global github.user "$GITHUB_USER"

if [[ "$OS" == "darwin" ]]; then
  git config --global credential.helper osxkeychain
fi

./install-fonts.sh

echo "Creating system directories..."
mkdir -p "$DEV_ROOT" "$NOTES_ROOT" "$DOWNLOADS_ROOT" "$CACHE_ROOT"\
 "$LABS_ROOT" "$APPS_ROOT" "$TOOLS_ROOT" "$OSS_ROOT" "$FLOW_WS_ROOT"

if [[ "$OS" == "darwin" ]]; then
  echo "Setting up macOS defaults..."
  ./macos.sh
fi
