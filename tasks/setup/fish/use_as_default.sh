#!/usr/bin/env bash

#MISE description="Setup fish as the default shell"
#MISE depends=["setup:install:packages"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

current_login_shell() {
  case "$(uname -s)" in
    Darwin)
      dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}'
      ;;
    Linux)
      getent passwd "$(id -un)" | cut -d: -f7
      ;;
    *)
      echo "${SHELL:-}"
      ;;
  esac
}

if command -v fish &> /dev/null; then
  FISH_PATH=$(command -v fish)
  CURRENT_SHELL=$(current_login_shell)

  if [[ "$CURRENT_SHELL" == "$FISH_PATH" ]]; then
    echo "Fish is already the default login shell."
    exit 0
  fi

  if [[ ! -r /dev/tty ]]; then
    echo "Fish is installed at $FISH_PATH, but there is no TTY for a login shell prompt."
    echo "Run this manually when ready: chsh -s \"$FISH_PATH\" \"$(id -un)\""
    exit 0
  fi

  read -r -p "Set fish ($FISH_PATH) as your default login shell? [y/N] " REPLY </dev/tty
  case "$REPLY" in
    [Yy]|[Yy][Ee][Ss])
      if ! grep -Fxq "$FISH_PATH" /etc/shells; then
        echo "Adding fish to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells
      fi

      echo "Setting fish as default shell..."
      chsh -s "$FISH_PATH" "$(id -un)"
      echo "Default shell set to fish. Changes will take effect on next login."
      ;;
    *)
      echo "Leaving default shell unchanged."
      ;;
  esac
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
