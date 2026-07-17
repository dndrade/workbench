#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "fish shell" [ "$SHELL" = "/usr/bin/fish" ]
check "user" [ "$(whoami)" = "vscode" ]
check "bun" bun --version
check "git" git --version
check "gh" gh --version

# TODO: add a real scaffold check, e.g.:
# check "install deps" bun install
# check "build" bun run build
# Left as a placeholder -- filling this in requires knowing the actual
# package.json script names in src/svelte's generated project.

# Report result
reportResults
