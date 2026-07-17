#!/usr/bin/env bash
set -euo pipefail

: "${TEMPLATE_ID:?TEMPLATE_ID is required}"
: "${REQUESTED_NAMESPACE:=}"
: "${DEFAULT_NAMESPACE:=}"

if [[ ! "${TEMPLATE_ID}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
	echo "TEMPLATE_ID contains unsupported characters: ${TEMPLATE_ID}" >&2
	exit 2
fi

template_file="src/${TEMPLATE_ID}/.devcontainer/devcontainer.json"

if [[ ! -f "${template_file}" ]]; then
	echo "Template configuration does not exist: ${template_file}" >&2
	exit 1
fi

jq empty "${template_file}"

image="$(jq -er '.image' "${template_file}")"
: "${image:?Template image is required}"

if [[ -n "${REQUESTED_NAMESPACE}" ]]; then
	namespace="${REQUESTED_NAMESPACE}"
else
	namespace="${DEFAULT_NAMESPACE}"
fi

namespace="$(tr '[:upper:]' '[:lower:]' <<< "${namespace}")"
namespace="${namespace#/}"
namespace="${namespace%/}"

: "${namespace:?Template namespace is required}"

printf 'image=%s\n' "${image}"
printf 'namespace=%s\n' "${namespace}"
