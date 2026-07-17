#!/usr/bin/env bash
set -euo pipefail

: "${REGISTRY:?REGISTRY is required}"
: "${NAMESPACE:?NAMESPACE is required}"
: "${TEMPLATES_PATH:?TEMPLATES_PATH is required}"

if [[ ! -d "${TEMPLATES_PATH}" ]]; then
	echo "Templates path does not exist: ${TEMPLATES_PATH}" >&2
	exit 1
fi

if ! command -v devcontainer >/dev/null 2>&1; then
	echo "The Dev Container CLI is required but was not found" >&2
	exit 1
fi

normalized_registry="${REGISTRY#https://}"
normalized_registry="${normalized_registry#http://}"
normalized_registry="${normalized_registry%/}"

normalized_namespace="$(tr '[:upper:]' '[:lower:]' <<< "${NAMESPACE}")"
normalized_namespace="${normalized_namespace#/}"
normalized_namespace="${normalized_namespace%/}"

: "${normalized_registry:?REGISTRY resolves to an empty value}"
: "${normalized_namespace:?NAMESPACE resolves to an empty value}"

devcontainer templates publish \
	--registry "${normalized_registry}" \
	--namespace "${normalized_namespace}" \
	"${TEMPLATES_PATH}"
