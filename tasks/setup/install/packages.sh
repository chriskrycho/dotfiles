#!/usr/bin/env bash

#MISE description="Install packages from Brewfile"
#MISE depends=["setup:install:homebrew"]
echo "Installing Homebrew packages"
echo "DEBUG: $PATH"
brew bundle install
