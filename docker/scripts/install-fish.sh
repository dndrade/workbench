#!/usr/bin/env bash
set -euo pipefail

username="${1:?usage: install-fish.sh <username>}"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends fish
rm -rf /var/lib/apt/lists/*

fish_path="$(command -v fish)"

if ! grep -Fxq "${fish_path}" /etc/shells; then
	echo "${fish_path}" >> /etc/shells
fi

usermod --shell "${fish_path}" "${username}"

actual_shell="$(getent passwd "${username}" | cut -d: -f7)"
if [[ "${actual_shell}" != "${fish_path}" ]]; then
	echo "Expected ${username} shell ${fish_path}, found ${actual_shell}" >&2
	exit 1
fi

fish --version
