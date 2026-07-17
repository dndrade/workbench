#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE_REPOSITORY:?IMAGE_REPOSITORY is required}"
: "${VERSION:?VERSION is required}"
: "${SOURCE_IMAGE:?SOURCE_IMAGE is required}"
: "${PUBLISH_LATEST:=false}"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
tags_script="${script_dir}/tags.sh"

if [[ ! -x "${tags_script}" ]]; then
	echo "Tag resolver is missing or not executable: ${tags_script}" >&2
	exit 1
fi

if ! docker image inspect "${SOURCE_IMAGE}" >/dev/null 2>&1; then
	echo "Source image is unavailable locally: ${SOURCE_IMAGE}" >&2
	exit 1
fi

mapfile -t tags < <(
	IMAGE_REPOSITORY="${IMAGE_REPOSITORY}" \
	VERSION="${VERSION}" \
	PUBLISH_LATEST="${PUBLISH_LATEST}" \
	"${tags_script}"
)

if (( ${#tags[@]} == 0 )); then
	echo "No publish tags were generated" >&2
	exit 1
fi

for tag in "${tags[@]}"; do
	echo "Tagging ${SOURCE_IMAGE} as ${tag}"
	docker tag "${SOURCE_IMAGE}" "${tag}"
done

for tag in "${tags[@]}"; do
	echo "Pushing ${tag}"
	docker push "${tag}"
done
