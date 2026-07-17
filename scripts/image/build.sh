#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE:?IMAGE is required}"
: "${DOCKERFILE:=docker/base/Dockerfile}"
: "${CONTEXT:=.}"
: "${PLATFORM:=linux/amd64}"
: "${LOAD:=true}"

case "${LOAD}" in
	true|false) ;;
	*)
		echo "LOAD must be 'true' or 'false'" >&2
		exit 2
		;;
esac

if [[ ! -f "${DOCKERFILE}" ]]; then
	echo "Dockerfile does not exist: ${DOCKERFILE}" >&2
	exit 1
fi

if [[ ! -d "${CONTEXT}" ]]; then
	echo "Build context does not exist: ${CONTEXT}" >&2
	exit 1
fi

args=(
	--file "${DOCKERFILE}"
	--platform "${PLATFORM}"
	--tag "${IMAGE}"
)

if [[ "${LOAD}" == "true" ]]; then
	args+=(--load)
fi

if [[ -n "${BUILD_CACHE_FROM:-}" ]]; then
	args+=(--cache-from "${BUILD_CACHE_FROM}")
fi

if [[ -n "${BUILD_CACHE_TO:-}" ]]; then
	args+=(--cache-to "${BUILD_CACHE_TO}")
fi

echo "Building image: ${IMAGE}"
docker buildx build "${args[@]}" "${CONTEXT}"
