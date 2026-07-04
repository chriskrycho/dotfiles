#!/usr/bin/env bash

#MISE description="Set up Rust toolchain"
#MISE depends=["setup:install:packages", "setup:configs"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

RUSTUP_PREFIX="$(brew --prefix rustup)"
export PATH="$RUSTUP_PREFIX/bin:$HOME/.cargo/bin:$PATH"

echo "Updating Rust stable toolchain..."
rustup update stable
