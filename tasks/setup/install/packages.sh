#!/usr/bin/env bash

#MISE description="Install packages from Brewfile"
#MISE depends=["setup:install:homebrew"]

# Source Homebrew environment (each Mise task runs in its own subshell)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing Homebrew packages"
brew bundle install
