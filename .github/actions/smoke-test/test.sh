#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE:?IMAGE is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
	echo "Docker image is unavailable locally: ${IMAGE}" >&2
	exit 1
fi

fish_script="$(
	cat <<'FISH'

set actual_bun_version (bun --version)
set actual_username (whoami)
set configured_shell (getent passwd "$actual_username" | cut -d: -f7)

test "$actual_bun_version" = "$EXPECTED_BUN_VERSION"
test "$actual_username" = "$EXPECTED_USERNAME"
test "$configured_shell" = "/usr/bin/fish"

fish --version
git --version
gh --version
FISH
)"

docker run --rm 	--entrypoint /usr/bin/fish 	--env EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" 	--env EXPECTED_USERNAME="${EXPECTED_USERNAME}" 	"${IMAGE}" 	-lc "${fish_script}"
