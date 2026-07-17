#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE:?IMAGE is required}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/../.." && pwd)"
smoke_test="${repo_root}/.github/actions/smoke-test/test.sh"

if [[ ! -x "${smoke_test}" ]]; then
	echo "Image smoke-test script is missing or not executable: ${smoke_test}" >&2
	exit 1
fi

"${smoke_test}"
