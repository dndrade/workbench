#!/usr/bin/env bash
set -euo pipefail

# Shared by publish-image.yaml and publish-template.yaml's "guard" job.
# Decides whether this run is allowed to publish. Rules:
#   - Tag pushes must match a strict "vX.Y.Z" release pattern. Pre-release
#     tags like v1.2.3-rc1 are not published as floating major/minor tags.
#   - workflow_dispatch is only allowed from main, so a manual run from a
#     feature branch can never publish unreleased content or overwrite a
#     floating tag.
#   - Branch pushes to main only proceed if they touched relevant paths
#     (passed in via the RELEVANT env var, from the caller's own
#     dorny/paths-filter job).
#   - Anything else is refused by default (fail closed).
#
# Reads: GITHUB_REF_TYPE, GITHUB_REF_NAME, GITHUB_EVENT_NAME (all provided
# automatically by Actions), and RELEVANT (set explicitly by the caller).
# Writes: proceed=true|false to GITHUB_OUTPUT.

: "${RELEVANT:=}"

if [[ "${GITHUB_REF_TYPE}" == "tag" ]]; then
	if [[ ! "${GITHUB_REF_NAME}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Tag '${GITHUB_REF_NAME}' is not a strict release tag (vX.Y.Z)." >&2
		echo "Pre-release/RC tags are not published as floating version tags." >&2
		echo "proceed=false" >>"$GITHUB_OUTPUT"
		exit 0
	fi
	echo "proceed=true" >>"$GITHUB_OUTPUT"

elif [[ "${GITHUB_EVENT_NAME}" == "workflow_dispatch" ]]; then
	if [[ "${GITHUB_REF_NAME}" != "main" ]]; then
		echo "Manual dispatch from '${GITHUB_REF_NAME}' refused; only 'main' is allowed." >&2
		echo "proceed=false" >>"$GITHUB_OUTPUT"
		exit 0
	fi
	echo "proceed=true" >>"$GITHUB_OUTPUT"

elif [[ "${GITHUB_REF_NAME}" == "main" ]]; then
	echo "proceed=${RELEVANT}" >>"$GITHUB_OUTPUT"

else
	echo "Refusing to publish from ref '${GITHUB_REF_NAME}'." >&2
	echo "proceed=false" >>"$GITHUB_OUTPUT"
fi
