#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE:?IMAGE is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

docker run --rm \
	-e EXPECTED_BUN_VERSION \
	-e EXPECTED_USERNAME \
	"${IMAGE}" \
	fish -lc '
		test "$(bun --version)" = "$EXPECTED_BUN_VERSION"
		fish --version
		git --version
		gh --version
		test "$(whoami)" = "$EXPECTED_USERNAME"
		test "$SHELL" = "/usr/bin/fish"
	'