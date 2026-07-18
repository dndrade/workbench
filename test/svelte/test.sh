#!/bin/bash
cd "$(dirname "$0")" || exit 1
# shellcheck disable=SC1091 # copied in alongside this script by build.sh at runtime
source test-utils.sh

: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

# Template specific tests
check "distro" lsb_release -c
check "fish shell" [ "$SHELL" = "/usr/bin/fish" ]
check "user matches expected username" [ "$(whoami)" = "$EXPECTED_USERNAME" ]
check "bun version matches expected" bash -c "bun --version | grep -qx \"${EXPECTED_BUN_VERSION}\""
check "git" git --version
check "gh" gh --version

if [[ "${CLAUDE_ENABLED:-false}" == "true" ]]; then
	check "claude code installed" claude --version
fi

# Report result
reportResults