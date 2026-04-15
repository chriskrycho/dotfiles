#!/usr/bin/env bash

#MISE description="Fix Zed remote extension permissions on Ona environments"

if ! command -v ona &> /dev/null; then
    echo "Not an Ona environment, skipping."
    exit 0
fi

# Root-owned .tmp dirs block extension install in Zed remote sessions.
find ~/.local/share/zed/remote_extensions -user root -exec sudo chown -R vscode:vscode {} + 2>/dev/null
