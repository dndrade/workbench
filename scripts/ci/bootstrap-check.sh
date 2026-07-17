#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE:?IMAGE is required}"
: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${IMAGE_RELEASED:?IMAGE_RELEASED is required}"

case "${IMAGE_RELEASED}" in
	true|false) ;;
	*)
		echo "IMAGE_RELEASED must be 'true' or 'false'" >&2
		exit 2
		;;
esac

if [[ ! "${TEMPLATE_ID}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${TEMPLATE_ID}" >&2
	exit 2
fi

template_file="src/${TEMPLATE_ID}/.devcontainer/devcontainer.json"

if [[ ! -f "${template_file}" ]]; then
	echo "Template Dev Container configuration does not exist: ${template_file}" >&2
	exit 1
fi

jq empty "${template_file}"

configured_image="$(jq -er '.image' "${template_file}")" || {
	echo "Template must define a non-empty .image value: ${template_file}" >&2
	exit 1
}

if [[ "${configured_image}" != "${IMAGE}" ]]; then
	echo "Configured template image does not match the expected release image." >&2
	echo "Configured: ${configured_image}" >&2
	echo "Expected:   ${IMAGE}" >&2
	exit 1
fi

image_exists=false
if docker buildx imagetools inspect "${IMAGE}" >/dev/null 2>&1; then
	image_exists=true
fi

echo "Template: ${TEMPLATE_ID}"
echo "Required image: ${IMAGE}"
echo "Image released in this run: ${IMAGE_RELEASED}"
echo "Image already exists: ${image_exists}"

if [[ "${IMAGE_RELEASED}" == "true" ]]; then
	echo "Bootstrap path: the image must be published before template validation."
	echo "status=publish-first"
	exit 0
fi

if [[ "${image_exists}" == "true" ]]; then
	echo "Established path: the template may use the existing published image."
	echo "status=ready"
	exit 0
fi

cat >&2 <<EOF
Template validation cannot continue.

The template references:
  ${IMAGE}

That image was not released by this workflow run and does not currently exist
in the registry.

For the first repository release, release the image component before the
template component. For later template-only releases, keep the referenced
major image tag published.
EOF

exit 1