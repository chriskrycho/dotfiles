#!/usr/bin/env bash

#MISE description="Install tide prompt plugin for fish via Fisher"
#MISE depends=["setup:fish:fisher"]

if command -v fish &> /dev/null; then
  if fish -c "type -q tide" 2>/dev/null; then
    echo "Tide already installed."
  else
    echo "Installing Tide..."
    fish -c "fisher install IlanCosman/tide@v6"
    echo "Tide installed. Run 'tide configure' to set up your prompt."
  fi
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
