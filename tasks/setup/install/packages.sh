#!/usr/bin/env bash

#MISE description = "Install packages from Brewfile"
#MISE depends = ["install:homebrew"]

brew bundle install
