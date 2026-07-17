#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"
: "${IMAGE:=}"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/../.." && pwd)"
build_script="${repo_root}/.github/actions/smoke-test-template/build.sh"
test_script="${repo_root}/.github/actions/smoke-test-template/test.sh"

for required_script in "${build_script}" "${test_script}"; do
	if [[ ! -x "${required_script}" ]]; then
		echo "Template smoke-test script is missing or not executable: ${required_script}" >&2
		exit 1
	fi
done

TEMPLATE_ID="${TEMPLATE_ID}" \
IMAGE="${IMAGE}" \
"${build_script}"

TEMPLATE_ID="${TEMPLATE_ID}" \
EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" \
EXPECTED_USERNAME="${EXPECTED_USERNAME}" \
"${test_script}"
