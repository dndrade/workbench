#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_TAG:?RELEASE_TAG is required}"

if [[ ! "${RELEASE_TAG}" =~ -v([0-9]+)\.([0-9]+)\.([0-9]+)([-+][0-9A-Za-z.-]+)?$ ]]; then
	echo "Release tag must end with a semantic version, such as workbench-base-v0.2.0" >&2
	echo "Received: ${RELEASE_TAG}" >&2
	exit 2
fi

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"
suffix="${BASH_REMATCH[4]:-}"
version="${major}.${minor}.${patch}${suffix}"

printf 'version=%s\n' "${version}"
printf 'major=%s\n' "${major}"
printf 'minor=%s\n' "${minor}"
printf 'patch=%s\n' "${patch}"
