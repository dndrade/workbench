#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"
: "${IMAGE:=}"

if [[ ! "${TEMPLATE_ID}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${TEMPLATE_ID}" >&2
	exit 2
fi

src_dir="/tmp/${TEMPLATE_ID}"

# 1. Render + resolve options
TEMPLATE_ID="${TEMPLATE_ID}" OUTPUT_DIR="${src_dir}" scripts/template/render.sh
TEMPLATE_ID="${TEMPLATE_ID}" TEMPLATE_DIR="${src_dir}" IMAGE="${IMAGE}" scripts/template/instantiate.sh

# 2. Copy in the assertion script + shared test-utils
test_dir="test/${TEMPLATE_ID}"
dest_dir="${src_dir}/test-project"
mkdir -p "${dest_dir}"
cp -Rp "${test_dir}/." "${dest_dir}"
cp -Rp test/test-utils/. "${dest_dir}"

# 3. Boot the container
if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
	unset SSH_AUTH_SOCK
fi

devcontainer up \
	--id-label "test-container=${TEMPLATE_ID}" \
	--workspace-folder "${src_dir}"

# 4. Run the assertions inside the container
devcontainer exec \
	--workspace-folder "${src_dir}" \
	env EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" EXPECTED_USERNAME="${EXPECTED_USERNAME}" \
	bash test-project/test.sh