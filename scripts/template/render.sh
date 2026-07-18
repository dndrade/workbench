#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${OUTPUT_DIR:?OUTPUT_DIR is required}"

if [[ ! "${TEMPLATE_ID}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${TEMPLATE_ID}" >&2
	exit 2
fi

source_dir="src/${TEMPLATE_ID}"

if [[ ! -d "${source_dir}" ]]; then
	echo "Template directory does not exist: ${source_dir}" >&2
	exit 1
fi

if [[ ! -f "${source_dir}/devcontainer-template.json" ]]; then
	echo "Template metadata is missing: ${source_dir}/devcontainer-template.json" >&2
	exit 1
fi

if [[ ! -f "${source_dir}/.devcontainer/devcontainer.json" ]]; then
	echo "Dev Container configuration is missing: ${source_dir}/.devcontainer/devcontainer.json" >&2
	exit 1
fi

jq empty "${source_dir}/devcontainer-template.json"
jq empty "${source_dir}/.devcontainer/devcontainer.json"

rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"
cp -Rp "${source_dir}/." "${OUTPUT_DIR}/"

# Merge shared template options (e.g. `claude`) into this template's metadata
TEMPLATE_ID="${TEMPLATE_ID}" OUTPUT_DIR="${OUTPUT_DIR}" scripts/template/merge-options.sh

jq empty "${OUTPUT_DIR}/devcontainer-template.json"
jq empty "${OUTPUT_DIR}/.devcontainer/devcontainer.json"

echo "Rendered template '${TEMPLATE_ID}' to ${OUTPUT_DIR}"