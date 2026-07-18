#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${OUTPUT_DIR:?OUTPUT_DIR is required}"

metadata_file="${OUTPUT_DIR}/devcontainer-template.json"
shared_options_file="scripts/template/shared-options.json"

if [[ ! -f "${metadata_file}" ]]; then
	echo "Template metadata is missing: ${metadata_file}" >&2
	exit 1
fi

if [[ -f "${shared_options_file}" ]]; then
	jq empty "${shared_options_file}"
	tmp_file="$(mktemp)"
	# shared options apply first; a template's own options (same key) win,
	# so individual templates can still override description/default
	jq --slurpfile shared "${shared_options_file}" \
		'.options = ($shared[0] + (.options // {}))' \
		"${metadata_file}" > "${tmp_file}"
	mv "${tmp_file}" "${metadata_file}"
fi

jq empty "${metadata_file}"