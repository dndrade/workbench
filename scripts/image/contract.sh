#!/usr/bin/env bash
set -euo pipefail

: "${DOCKERFILE:=docker/base/Dockerfile}"

if [[ ! -f "${DOCKERFILE}" ]]; then
	echo "Dockerfile does not exist: ${DOCKERFILE}" >&2
	exit 1
fi

bun_version="$(
	sed -n 's/^ARG[[:space:]]\+BUN_VERSION=//p' "${DOCKERFILE}" |
		head -n 1
)"

username="$(
	sed -n 's/^ARG[[:space:]]\+USERNAME=//p' "${DOCKERFILE}" |
		head -n 1
)"

: "${bun_version:?Could not resolve BUN_VERSION from ${DOCKERFILE}}"
: "${username:?Could not resolve USERNAME from ${DOCKERFILE}}"

printf 'bun-version=%s\n' "${bun_version}"
printf 'username=%s\n' "${username}"
