#!/usr/bin/env bash
set -euo pipefail

# Pulls the generated release notes for GITHUB_REF_NAME back out and opens a
# PR prepending them to CHANGELOG.md, for publish-image.yaml's "publish" job.
#
# Reads: GITHUB_REF_NAME (provided automatically by Actions), GH_TOKEN (set
# explicitly by the calling step from secrets.GITHUB_TOKEN).

notes="$(gh release view "${GITHUB_REF_NAME}" --json body -q .body)"

if [[ -z "${notes}" ]]; then
	echo "No release notes returned for ${GITHUB_REF_NAME}; skipping changelog PR." >&2
	exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

branch="changelog-${GITHUB_REF_NAME}"
git checkout -b "${branch}"

{
	echo "## ${GITHUB_REF_NAME} - $(date -u +%Y-%m-%d)"
	echo
	echo "${notes}"
	echo
	cat CHANGELOG.md 2>/dev/null || true
} >CHANGELOG.md.tmp
mv CHANGELOG.md.tmp CHANGELOG.md

git add CHANGELOG.md
if git diff --cached --quiet; then
	echo "No changelog changes to commit."
	exit 0
fi

git commit -m "Update CHANGELOG.md for ${GITHUB_REF_NAME} [skip ci]"
# Bot-owned, tag-scoped branch -- force push is fine if a stale copy from a
# prior failed run is already sitting on the remote.
git push --force origin "${branch}"

# Fill in the PR body from the same template a human would use, 
# so that the PR is consistent with the rest of the repo.
template=".github/PULL_REQUEST_TEMPLATE/changelog_update.md"
TAG="${GITHUB_REF_NAME}" NOTES="${notes}" python3 - "${template}" >pr_body.md <<'PY_EOF'
import os
import sys

with open(sys.argv[1]) as f:
	content = f.read()

content = content.replace("__TAG__", os.environ["TAG"])
content = content.replace("__NOTES__", os.environ["NOTES"])

sys.stdout.write(content)
PY_EOF

if [[ -n "$(gh pr list --head "${branch}" --state open --json number -q '.[0].number')" ]]; then
	echo "PR for ${branch} already open."
else
	gh pr create \
		--title "Update CHANGELOG.md for ${GITHUB_REF_NAME}" \
		--body-file pr_body.md \
		--head "${branch}"
fi
