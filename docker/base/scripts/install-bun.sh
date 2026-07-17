#!/usr/bin/env bash
set -euo pipefail

username="${1:?usage: install-bun.sh <username> <version>}"
version="${2:?usage: install-bun.sh <username> <version>}"

home_dir="$(getent passwd "${username}" | cut -d: -f6)"
if [[ -z "${home_dir}" ]]; then
	echo "Could not resolve home directory for ${username}" >&2
	exit 1
fi

bun_dir="${home_dir}/.bun"
bun_bin="${bun_dir}/bin/bun"

install -d -o "${username}" -g "${username}" "${bun_dir}"

curl -fsSL https://bun.com/install \
    | runuser -u "${username}" -- \
        env \
            HOME="${home_dir}" \
            BUN_INSTALL="${bun_dir}" \
        bash -s -- "bun-v${version}"

installed_version="$("${bun_bin}" --version)"
if [[ "${installed_version}" != "${version}" ]]; then
	echo "Expected Bun ${version}, installed ${installed_version}" >&2
	exit 1
fi
