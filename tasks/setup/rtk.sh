#!/usr/bin/env bash

#MISE description="Initialize rtk for Claude Code"
#MISE depends=["setup:install:packages"]

if command -v rtk &> /dev/null; then
  echo "Initializing rtk for Claude Code..."
  rtk init -g
  echo "rtk initialized."
else
  echo "rtk not found. Make sure it's installed via your Brewfile."
fi
