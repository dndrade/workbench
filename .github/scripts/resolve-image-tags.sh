#!/usr/bin/env bash
set -euo pipefail

# Resolves the GHCR tag lists for the base and Svelte images, for
# publish-image.yaml's "publish" job.
#
# Reads: GITHUB_REPOSITORY_OWNER, GITHUB_SHA, GITHUB_REF_TYPE, GITHUB_REF_NAME
# (all provided automatically by Actions).
# Writes: base, svelte (multi-line tag lists) and base_reference to
# GITHUB_OUTPUT.

owner="$(echo "${GITHUB_REPOSITORY_OWNER}" | tr '[:upper:]' '[:lower:]')"
sha_tag="sha-${GITHUB_SHA::12}"

if [[ "${GITHUB_REF_TYPE}" == "tag" ]]; then
	version="${GITHUB_REF_NAME#v}"
	major_minor="${version%.*}"
	major="${version%%.*}"

	{
		echo "base<<EOF"
		echo "ghcr.io/${owner}/workbench-base:${version}"
		echo "ghcr.io/${owner}/workbench-base:${major_minor}"
		echo "ghcr.io/${owner}/workbench-base:${major}"
		echo "ghcr.io/${owner}/workbench-base:${sha_tag}"
		echo "EOF"

		echo "svelte<<EOF"
		echo "ghcr.io/${owner}/workbench-svelte:${version}"
		echo "ghcr.io/${owner}/workbench-svelte:${major_minor}"
		echo "ghcr.io/${owner}/workbench-svelte:${major}"
		echo "ghcr.io/${owner}/workbench-svelte:${sha_tag}"
		echo "EOF"

		echo "base_reference=ghcr.io/${owner}/workbench-base:${version}"
	} >>"$GITHUB_OUTPUT"
else
	{
		echo "base<<EOF"
		echo "ghcr.io/${owner}/workbench-base:main"
		echo "ghcr.io/${owner}/workbench-base:${sha_tag}"
		echo "EOF"

		echo "svelte<<EOF"
		echo "ghcr.io/${owner}/workbench-svelte:main"
		echo "ghcr.io/${owner}/workbench-svelte:${sha_tag}"
		echo "EOF"

		echo "base_reference=ghcr.io/${owner}/workbench-base:main"
	} >>"$GITHUB_OUTPUT"
fi
