#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	curl \
	git \
	gh \
	jq \
	less \
	openssh-client \
	ripgrep \
	rsync \
	shellcheck \
	tree \
	unzip \
	vim \
	zip

rm -rf /var/lib/apt/lists/*
