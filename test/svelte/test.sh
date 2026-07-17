#!/bin/bash
cd "$(dirname "$0")" || exit 1
# shellcheck disable=SC1091 # copied in alongside this script by build.sh at runtime
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "fish shell" [ "$SHELL" = "/usr/bin/fish" ]
check "user" [ "$(whoami)" = "vscode" ]
check "bun" bun --version
check "git" git --version
check "gh" gh --version

# Report result
reportResults