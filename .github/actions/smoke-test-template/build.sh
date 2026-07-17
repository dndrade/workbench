#!/usr/bin/env bash
set -euo pipefail

template_id="${1:?usage: build.sh <template-id>}"

shopt -s dotglob

src_dir="/tmp/${template_id}"
rm -rf "${src_dir}"
cp -R "src/${template_id}" "${src_dir}"

pushd "${src_dir}" >/dev/null

# Substitute templateOptions with their defaults, if the template declares any.
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
		find . -type f -print0 | xargs -0 sed -i "s/${option_key}/${option_value_escaped}/g"
	done
fi

popd >/dev/null

test_dir="test/${template_id}"
dest_dir="${src_dir}/test-project"

if [[ -d "${test_dir}" ]] && find "${test_dir}" -mindepth 1 -print -quit | grep -q .; then
	echo "Copying test/${template_id} into the workspace as test-project"
	mkdir -p "${dest_dir}"
	cp -Rp "${test_dir}/." "${dest_dir}"
	cp -Rp test/test-utils/. "${dest_dir}"
else
	echo "test/${template_id} has no test files yet; the baseline check will run instead."
fi

echo "Building dev container for '${template_id}'"
id_label="test-container=${template_id}"
devcontainer up --id-label "${id_label}" --workspace-folder "${src_dir}"