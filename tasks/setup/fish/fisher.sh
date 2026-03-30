#!/usr/bin/env bash

#MISE description="Install Fisher plugin manager for fish"
#MISE depends=["setup:fish:use_as_default"]

if command -v fish &> /dev/null; then
  if fish -c "type -q fisher" 2>/dev/null; then
    echo "Fisher already installed."
  else
    echo "Installing Fisher..."
    fish -c "set -g fisher_path ~/.local/share/fisher && curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    echo "Fisher installed."
  fi
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
