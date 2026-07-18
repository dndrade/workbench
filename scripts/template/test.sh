#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"
: "${IMAGE:=}"
: "${OPTION_OVERRIDES:=}"
: "${CLAUDE_ENABLED:=false}"

if [[ ! "${TEMPLATE_ID}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${TEMPLATE_ID}" >&2
	exit 2
fi

src_dir="/tmp/${TEMPLATE_ID}"

TEMPLATE_ID="${TEMPLATE_ID}" OUTPUT_DIR="${src_dir}" scripts/template/render.sh
TEMPLATE_ID="${TEMPLATE_ID}" TEMPLATE_DIR="${src_dir}" IMAGE="${IMAGE}" OPTION_OVERRIDES="${OPTION_OVERRIDES}" scripts/template/instantiate.sh

test_dir="test/${TEMPLATE_ID}"
dest_dir="${src_dir}/test-project"
mkdir -p "${dest_dir}"
cp -Rp "${test_dir}/." "${dest_dir}"
cp -Rp test/test-utils/. "${dest_dir}"

echo "Building dev container for '${TEMPLATE_ID}'"

devcontainer up \
	--id-label "test-container=${TEMPLATE_ID}" \
	--workspace-folder "${src_dir}"

devcontainer exec \
	--id-label "test-container=${TEMPLATE_ID}" \
	--workspace-folder "${src_dir}" \
	env EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" EXPECTED_USERNAME="${EXPECTED_USERNAME}" CLAUDE_ENABLED="${CLAUDE_ENABLED}" \
	bash test-project/test.sh