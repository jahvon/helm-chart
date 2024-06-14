#!/bin/sh

set -e

echo "Cloning workspaces..."

collections=(
  "jahvon/system"
  "jahvon/kube"
)

for repo in "${collections[@]}"; do
  if [ -d "$HOME/workspace/github.com/$repo" ]; then
    echo "$repo already cloned"
  else
    git clone "https://github.com/$repo.git" "$HOME/workspace/github.com/$repo"
  fi
done


if [ $INCLUDE_PROJECTS ]; then
  projects=(
    "jahvon/flow"
    "jahvon/tuikit"
    "jahvon/echo-server"
    "jahvon/hubext"
  )

  for repo in "${projects[@]}"; do
    if [ -d "$HOME/workspace/github.com/$repo" ]; then
      echo "$repo already cloned"
    else
      git clone "https://github.com/$repo.git" "$HOME/workspace/github.com/$repo"
    fi
  done
fi

if [ -d "$HOME/workspace/github.com/jahvon/tools" ]; then
  echo "tools directory already exist"
else
  mkdir -p "$HOME/workspace/github.com/jahvon/tools"
  echo "displayName: tools" > "$HOME/workspace/github.com/jahvon/tools/workspace.yaml"
fi

if [ -d "$HOME/workspace/github.com/jahvon/sandbox" ]; then
  echo "sandbox directory already exist"
else
  mkdir -p "$HOME/workspace/github.com/jahvon/sandbox"
  echo "displayName: sandbox" > "$HOME/workspace/github.com/jahvon/tools/workspace.yaml"
fi

echo "Syncing flow configuration..."

# IMPLEMENTME: flow init config -f config.yaml
if [ "$os_name" = "Darwin" ]; then
    dest_dir="$HOME/Library/Application Support/flow"
elif [ "$os_name" = "Linux" ]; then
    dest_dir="$HOME/.config/flow"
else
    echo "Unsupported operating system"
    exit 1
fi
