#!/usr/bin/env bash

setup_homebrew_env() {
  if command -v brew &>/dev/null; then
    return 0
  fi

  local brew_bin=""
  case "$(uname -s)" in
    Darwin)
      case "$(uname -m)" in
        arm64) brew_bin="/opt/homebrew/bin/brew" ;;
        *) brew_bin="/usr/local/bin/brew" ;;
      esac
      ;;
    Linux)
      brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
      ;;
  esac

  if [[ -x "$brew_bin" ]]; then
    eval "$("$brew_bin" shellenv)"
  fi
}

require_homebrew() {
  setup_homebrew_env

  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not available on PATH after setup." >&2
    exit 1
  fi
}
