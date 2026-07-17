#!/usr/bin/env bash
set -euo pipefail

# Resolves the GHCR tag lists for the base and Svelte images.
#
# Reads: RELEASE_TAG (e.g. "workbench-base-v0.2.0"), passed explicitly via
# the workflow_call/workflow_dispatch "tag" input -- NOT GITHUB_REF_NAME.
# This workflow is invoked by release-please.yaml via workflow_call, so the
# ambient ref context reflects main, not the release tag.
# Writes: base, svelte (multi-line tag lists) and base_reference to
# GITHUB_OUTPUT.
#

owner="$(echo "${GITHUB_REPOSITORY_OWNER}" | tr '[:upper:]' '[:lower:]')"

version="${RELEASE_TAG#workbench-base-v}"
major_minor="${version%.*}"
major="${version%%.*}"

{
	echo "base<<EOF"
	echo "ghcr.io/${owner}/workbench-base:${version}"
	echo "ghcr.io/${owner}/workbench-base:${major_minor}"
	echo "ghcr.io/${owner}/workbench-base:${major}"
	echo "EOF"

	echo "svelte<<EOF"
	echo "ghcr.io/${owner}/workbench-svelte:${version}"
	echo "ghcr.io/${owner}/workbench-svelte:${major_minor}"
	echo "ghcr.io/${owner}/workbench-svelte:${major}"
	echo "EOF"

	echo "base_reference=ghcr.io/${owner}/workbench-base:${version}"
} >>"$GITHUB_OUTPUT"