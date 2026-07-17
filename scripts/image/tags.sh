#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE_REPOSITORY:?IMAGE_REPOSITORY is required}"
: "${VERSION:?VERSION is required}"
: "${PUBLISH_LATEST:=false}"

case "${PUBLISH_LATEST}" in
	true|false) ;;
	*)
		echo "PUBLISH_LATEST must be 'true' or 'false'" >&2
		exit 2
		;;
esac

if [[ ! "${VERSION}" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)([-+][0-9A-Za-z.-]+)?$ ]]; then
	echo "VERSION must be semantic, such as 0.1.0 or v0.1.0" >&2
	exit 2
fi

normalized="${VERSION#v}"
core="${normalized%%[-+]*}"
IFS='.' read -r major minor patch <<< "${core}"

tags=(
	"${IMAGE_REPOSITORY}:${normalized}"
	"${IMAGE_REPOSITORY}:${major}.${minor}"
	"${IMAGE_REPOSITORY}:${major}"
)

if [[ "${PUBLISH_LATEST}" == "true" ]]; then
	tags+=("${IMAGE_REPOSITORY}:latest")
fi

printf '%s\n' "${tags[@]}"
