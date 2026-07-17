#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${IMAGE:=}"

template_id="${TEMPLATE_ID}"

if [[ ! "${template_id}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${template_id}" >&2
	exit 2
fi

shopt -s dotglob

template_dir="src/${template_id}"
src_dir="/tmp/${template_id}"

if [[ ! -d "${template_dir}" ]]; then
	echo "Template directory does not exist: ${template_dir}" >&2
	exit 1
fi

if [[ ! -f "${template_dir}/devcontainer-template.json" ]]; then
	echo "Template metadata is missing: ${template_dir}/devcontainer-template.json" >&2
	exit 1
fi

if [[ ! -f "${template_dir}/.devcontainer/devcontainer.json" ]]; then
	echo "Dev Container configuration is missing: ${template_dir}/.devcontainer/devcontainer.json" >&2
	exit 1
fi

jq empty "${template_dir}/devcontainer-template.json"
jq empty "${template_dir}/.devcontainer/devcontainer.json"

rm -rf "${src_dir}"
cp -R "${template_dir}" "${src_dir}"

pushd "${src_dir}" >/dev/null

option_property="$(jq -r '.options' devcontainer-template.json)"

if [[ -n "${option_property}" && "${option_property}" != "null" ]]; then
	mapfile -t options < <(jq -r '.options | keys[]' devcontainer-template.json)

	for option in "${options[@]}"; do
		option_key="\${templateOption:${option}}"
		option_value="$(jq -r ".options.${option}.default" devcontainer-template.json)"

		if [[ -z "${option_value}" || "${option_value}" == "null" ]]; then
			echo "Template '${template_id}' is missing a default value for option '${option}'" >&2
			exit 1
		fi

		echo "Replacing '${option_key}' with '${option_value}'"
		option_value_escaped="$(sed -e 's/[]\/$*.^[]/\\&/g' <<<"${option_value}")"
		find . -type f -print0 |
			xargs -0 sed -i "s/${option_key}/${option_value_escaped}/g"
	done
fi

if [[ -n "${IMAGE}" ]]; then
	echo "Using image override '${IMAGE}'"

	tmp_file="$(mktemp)"
	jq --arg image "${IMAGE}" \
		'.image = $image' \
		.devcontainer/devcontainer.json > "${tmp_file}"

	mv "${tmp_file}" .devcontainer/devcontainer.json
fi

jq empty devcontainer-template.json
jq empty .devcontainer/devcontainer.json

popd >/dev/null

test_dir="test/${template_id}"
dest_dir="${src_dir}/test-project"

if [[ -d "${test_dir}" ]] &&
	find "${test_dir}" -mindepth 1 -print -quit | grep -q .; then
	echo "Copying test/${template_id} into the workspace as test-project"
	mkdir -p "${dest_dir}"
	cp -Rp "${test_dir}/." "${dest_dir}"
	cp -Rp test/test-utils/. "${dest_dir}"
else
	echo "test/${template_id} has no test files yet; the baseline check will run instead."
fi

echo "Building dev container for '${template_id}'"
id_label="test-container=${template_id}"

devcontainer up \
	--id-label "${id_label}" \
	--workspace-folder "${src_dir}"