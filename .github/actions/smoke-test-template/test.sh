#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

template_id="${TEMPLATE_ID}"

if [[ ! "${template_id}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${template_id}" >&2
	exit 2
fi

src_dir="/tmp/${template_id}"
id_label="test-container=${template_id}"
test_script="${src_dir}/test-project/test.sh"

cleanup() {
	mapfile -t containers < <(
		docker container ls \
			--all \
			--quiet \
			--filter "label=${id_label}"
	)

	if (( ${#containers[@]} > 0 )); then
		docker rm -f "${containers[@]}" >/dev/null 2>&1 || true
	fi

	rm -rf "${src_dir}"
}
trap cleanup EXIT

if [[ ! -d "${src_dir}" ]]; then
	echo "Template workspace does not exist: ${src_dir}" >&2
	exit 1
fi

if [[ ! -f "${test_script}" ]]; then
	echo "Template test is required but was not found:" >&2
	echo "  test/${template_id}/test.sh" >&2
	exit 1
fi

echo "Running template acceptance test for '${template_id}'"

devcontainer exec \
	--workspace-folder "${src_dir}" \
	--id-label "${id_label}" \
	--remote-env EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" \
	--remote-env EXPECTED_USERNAME="${EXPECTED_USERNAME}" \
	/bin/sh -c '
		set -eu
		cd test-project

		if [ "$(id -u)" = "0" ]; then
			chmod +x test.sh
		else
			sudo chmod +x test.sh
		fi

		./test.sh
	'