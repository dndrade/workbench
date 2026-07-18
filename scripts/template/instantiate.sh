#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${TEMPLATE_DIR:?TEMPLATE_DIR is required}"
: "${IMAGE:=}"

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
	echo "Rendered template directory does not exist: ${TEMPLATE_DIR}" >&2
	exit 1
fi

metadata_file="${TEMPLATE_DIR}/devcontainer-template.json"
devcontainer_file="${TEMPLATE_DIR}/.devcontainer/devcontainer.json"

if [[ ! -f "${metadata_file}" ]]; then
	echo "Template metadata is missing: ${metadata_file}" >&2
	exit 1
fi

mapfile -t options < <(jq -r '.options // {} | keys[]' "${metadata_file}")

for option in "${options[@]}"; do
	option_value="$(jq -r --arg option "${option}" '.options[$option].default' "${metadata_file}")"

    if [[ "${option_value}" == "null" ]]; then
            echo "Template '${TEMPLATE_ID}' is missing a default value for option '${option}'" >&2
            exit 1
    fi

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
	done < <(find "${TEMPLATE_DIR}" -type f -print0)
done

if [[ -n "${IMAGE}" ]]; then
	tmp_file="$(mktemp)"
	jq --arg image "${IMAGE}" '.image = $image' "${devcontainer_file}" > "${tmp_file}"
	mv "${tmp_file}" "${devcontainer_file}"
fi

jq empty "${metadata_file}"
jq empty "${devcontainer_file}"

echo "Instantiated template '${TEMPLATE_ID}' in ${TEMPLATE_DIR}"