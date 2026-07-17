#!/usr/bin/env bash
set -euo pipefail

template_id="${1:?usage: test.sh <template-id>}"
: "${EXPECTED_BUN_VERSION:?EXPECTED_BUN_VERSION is required}"
: "${EXPECTED_USERNAME:?EXPECTED_USERNAME is required}"

src_dir="/tmp/${template_id}"
id_label="test-container=${template_id}"

cleanup() {
	local containers
	containers="$(docker container ls -f "label=${id_label}" -q)"
	if [[ -n "${containers}" ]]; then
		# shellcheck disable=SC2086
		docker rm -f ${containers} >/dev/null
	fi
	rm -rf "${src_dir}"
}
# Runs on success AND failure, unlike a bare cleanup line at the bottom of
# the script -- otherwise `set -e` aborts before cleanup on a failed test
# and leaks the container + tmp workspace.
trap cleanup EXIT

if [[ -f "${src_dir}/test-project/test.sh" ]]; then
	echo "Running custom smoke test for '${template_id}'"
	# shellcheck disable=SC2016 # single-quoted on purpose: these expand
	# inside the container, not on the host running this script.
	devcontainer exec --workspace-folder "${src_dir}" --id-label "${id_label}" /bin/sh -c '
		set -e
		cd test-project
		if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi
		./test.sh
	'
else
	echo "No test/${template_id}/test.sh yet; running the baseline tool check instead."
	echo "NOTE: this tests whatever image src/${template_id}/.devcontainer/devcontainer.json"
	echo "currently references (a published tag), not an image built from this branch's"
	echo "Dockerfile. Tool *presence* is asserted strictly below, but the Bun *version* is"
	echo "only compared informationally -- a mismatch just means the published image"
	echo "hasn't caught up with this branch yet, not a regression in this PR."
	# shellcheck disable=SC2016 # single-quoted on purpose: these expand
	# inside the container, not on the host running this script.
	devcontainer exec \
		--workspace-folder "${src_dir}" \
		--id-label "${id_label}" \
		--remote-env EXPECTED_BUN_VERSION="${EXPECTED_BUN_VERSION}" \
		--remote-env EXPECTED_USERNAME="${EXPECTED_USERNAME}" \
		fish -lc '
			set actual_bun_version (bun --version)
			if test "$actual_bun_version" != "$EXPECTED_BUN_VERSION"
				echo "NOTE: published image has Bun $actual_bun_version; this branch expects $EXPECTED_BUN_VERSION (informational only, not a failure)"
			end
			test -n "$actual_bun_version"
			fish --version
			git --version
			gh --version
			test "$(whoami)" = "$EXPECTED_USERNAME"
			test "$SHELL" = "/usr/bin/fish"
		'
fi