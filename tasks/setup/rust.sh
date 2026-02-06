#!/usr/bin/env bash

#MISE description="Set up Rust toolchain"
#MISE depends=["setup:install:packages", "setup:configs"]

# Source Homebrew environment
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH="$(brew --prefix rustup)/bin:$HOME/.cargo/bin:$PATH"

echo "Updating Rust stable toolchain..."
rustup update stable
