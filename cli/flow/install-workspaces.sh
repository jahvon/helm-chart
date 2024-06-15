#!/bin/sh

set -e

mkdir -p "$HOME/workspaces/github.com"

echo "Cloning workspaces..."

collections=(
  "jahvon/system"
  "jahvon/kube"
)

for repo in "${collections[@]}"; do
  if [ -d "$HOME/workspaces/github.com/$repo" ]; then
    echo "$repo already cloned"
  else
    git clone "https://github.com/$repo.git" "$HOME/workspaces/github.com/$repo"
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
    if [ -d "$HOME/workspaces/github.com/$repo" ]; then
      echo "$repo already cloned"
    else
      git clone "https://github.com/$repo.git" "$HOME/workspaces/github.com/$repo"
    fi
  done
fi

if [ -d "$HOME/workspaces/github.com/jahvon/tools" ]; then
  echo "tools directory already exist"
else
  mkdir -p "$HOME/workspaces/github.com/jahvon/tools"
  echo "displayName: tools" > "$HOME/workspace/github.com/jahvon/tools/workspace.yaml"
fi

if [ -d "$HOME/workspaces/github.com/jahvon/sandbox" ]; then
  echo "sandbox directory already exist"
else
  mkdir -p "$HOME/workspaces/github.com/jahvon/sandbox"
  echo "displayName: sandbox" > "$HOME/workspace/github.com/jahvon/tools/workspace.yaml"
fi
