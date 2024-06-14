#!/bin/bash

# f:verb=install f:named=autocompletions
# f:alias=completions
# f:desc=Install autocompletions for shell tools

set -e

if (command -v flow > /dev/null); then
  echo "Updating flow zsh autocompletion..."
  flow completion zsh > ~/.oh-my-zsh/completions/_flow
fi

if (command -v flux > /dev/null); then
  echo "Updating flux zsh autocompletion..."
  flux completion zsh > ~/.oh-my-zsh/completions/_flux
fi
