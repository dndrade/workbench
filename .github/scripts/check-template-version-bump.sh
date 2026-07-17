#!/usr/bin/env bash
set -euo pipefail

# Fails a tagged release if src/** changed since the previous tag but
# devcontainer-template.json's version field wasn't bumped to match.
# Only meaningful on tag pushes -- publish-template.yaml only runs this when
# GITHUB_REF_TYPE is "tag". Requires a full-history checkout (fetch-depth: 0,
# fetch-tags: true) to see previous tags.

template_json="src/svelte/devcontainer-template.json"

previous_tag="$(git tag --sort=-creatordate | grep -v "^${GITHUB_REF_NAME}$" | head -n1 || true)"

if [[ -z "${previous_tag}" ]]; then
	echo "No previous tag found -- nothing to compare against, skipping check."
	exit 0
fi

if git diff --quiet "${previous_tag}" HEAD -- src/; then
	echo "src/ unchanged since ${previous_tag} -- no version bump required."
	exit 0
fi

previous_version="$(git show "${previous_tag}:${template_json}" 2>/dev/null | jq -r .version || echo "")"

if [[ -z "${previous_version}" ]]; then
	echo "${template_json} didn't exist at ${previous_tag} -- nothing to compare against, skipping check."
	exit 0
fi

current_version="$(jq -r .version "${template_json}")"

if [[ "${current_version}" == "${previous_version}" ]]; then
	echo "src/ changed since ${previous_tag}, but version in ${template_json} is still ${current_version}." >&2
	echo "Bump the version field before tagging this release." >&2
	exit 1
fi

echo "Template version bumped: ${previous_version} -> ${current_version}. OK."
