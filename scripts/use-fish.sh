#!/usr/bin/env bash

if command -v fish &> /dev/null; then
  FISH_PATH=$(which fish)

  if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
  fi

  echo "Setting fish as default shell..."
  chsh -s "$FISH_PATH"
  echo "Default shell set to fish. Changes will take effect on next login."
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
