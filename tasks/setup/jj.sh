#!/usr/bin/env bash

#MISE description="Initialize jj in cloud workspace repos"

OBSIDIAN_WORKSPACE="/workspaces/obsidian"

if [[ -d "$OBSIDIAN_WORKSPACE" ]]; then
    if [[ ! -d "$OBSIDIAN_WORKSPACE/.jj" ]]; then
        echo "Initializing jj in $OBSIDIAN_WORKSPACE..."
        jj git init --colocate "$OBSIDIAN_WORKSPACE"
        echo "jj initialized."
    else
        echo "jj already initialized in $OBSIDIAN_WORKSPACE, skipping."
    fi
else
    echo "No cloud workspace found at $OBSIDIAN_WORKSPACE, skipping."
fi
