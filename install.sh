#!/usr/bin/env bash

dry_run=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            dry_run=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done


if [[ ! -f ~/.local/bin/mise ]]; then
    curl https://mise.run | sh
fi

if [[ ":$PATH:" != *":HOME/.local/bin:"* ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

mise --version
mise trust .
if [ "$dry_run" = true ]; then
    run setup --dry-run
else
    mise setup
fi
