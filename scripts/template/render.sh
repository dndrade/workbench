#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${OUTPUT_DIR:?OUTPUT_DIR is required}"
: "${IMAGE:=}"

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

metadata_file="${OUTPUT_DIR}/devcontainer-template.json"
devcontainer_file="${OUTPUT_DIR}/.devcontainer/devcontainer.json"

mapfile -t options < <(jq -r '.options // {} | keys[]' "${metadata_file}")

for option in "${options[@]}"; do
	option_value="$(jq -er --arg option "${option}" '.options[$option].default' "${metadata_file}")" || {
		echo "Template '${TEMPLATE_ID}' is missing a default value for option '${option}'" >&2
		exit 1
	}

	option_key="\${templateOption:${option}}"

	while IFS= read -r -d '' file; do
		python3 - "${file}" "${option_key}" "${option_value}" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
needle = sys.argv[2]
replacement = sys.argv[3]

try:
    content = path.read_text()
except UnicodeDecodeError:
    raise SystemExit(0)

if needle in content:
    path.write_text(content.replace(needle, replacement))
PY
	done < <(find "${OUTPUT_DIR}" -type f -print0)
done

if [[ -n "${IMAGE}" ]]; then
	tmp_file="$(mktemp)"
	jq --arg image "${IMAGE}" '.image = $image' "${devcontainer_file}" > "${tmp_file}"
	mv "${tmp_file}" "${devcontainer_file}"
fi

jq empty "${metadata_file}"
jq empty "${devcontainer_file}"

echo "Rendered template '${TEMPLATE_ID}' to ${OUTPUT_DIR}"
