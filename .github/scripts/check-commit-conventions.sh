#!/usr/bin/env bash
set -euo pipefail

# Checks whether the tag being pushed reflects the scale of change indicated
# by Conventional Commits messages since the previous tag.
#   - Any commit with a "!" breaking marker (e.g. "feat!:") or a
#     "BREAKING CHANGE:" footer requires a MAJOR bump -- hard failure if the
#     tag doesn't reflect that (semver.org rule 8).
#   - Any "feat:" commit without a breaking marker recommends at least a
#     MINOR bump -- a non-blocking warning if the tag only bumps patch
#     (semver.org rule 7).
# This validates the *image* version (the tag itself); it does not know
# about the template's independent version field -- see
# check-template-version-bump.sh for that.
# Only meaningful on tag pushes; requires full tag history (fetch-depth: 0,
# fetch-tags: true).

current_tag="${GITHUB_REF_NAME}"
current_version="${current_tag#v}"

previous_tag="$(git tag --sort=-creatordate | grep -v "^${current_tag}$" | head -n1 || true)"

if [[ -z "${previous_tag}" ]]; then
	echo "No previous tag found -- nothing to compare commit history against."
	exit 0
fi

previous_version="${previous_tag#v}"

IFS='.' read -r cur_major cur_minor cur_patch <<<"${current_version}"
IFS='.' read -r prev_major prev_minor prev_patch <<<"${previous_version}"

bump="none"
if [[ "${cur_major}" -gt "${prev_major}" ]]; then
	bump="major"
elif [[ "${cur_minor}" -gt "${prev_minor}" ]]; then
	bump="minor"
elif [[ "${cur_patch}" -gt "${prev_patch}" ]]; then
	bump="patch"
fi

has_breaking=false
has_feat=false

while IFS= read -r line; do
	if [[ "${line}" =~ ^[a-z]+(\([a-zA-Z0-9_/,-]+\))?!: ]] || [[ "${line}" == "BREAKING CHANGE:"* ]]; then
		has_breaking=true
	fi
	if [[ "${line}" =~ ^feat(\([a-zA-Z0-9_/,-]+\))?: ]]; then
		has_feat=true
	fi
done < <(git log "${previous_tag}..HEAD" --pretty=format:'%s%n%b')

if [[ "${has_breaking}" == "true" && "${bump}" != "major" ]]; then
	echo "Commits since ${previous_tag} include a breaking change (a '!' marker or a" >&2
	echo "'BREAKING CHANGE:' footer), but ${current_tag} is only a '${bump}' bump over" >&2
	echo "${previous_tag}. A breaking change requires a MAJOR version bump." >&2
	exit 1
fi

if [[ "${has_feat}" == "true" && "${bump}" == "patch" ]]; then
	echo "::warning::Commits since ${previous_tag} include a 'feat:' commit, but ${current_tag} is only a patch bump. Consider a MINOR bump instead."
fi

echo "Commit-convention check passed for ${current_tag} (bump: ${bump})."
