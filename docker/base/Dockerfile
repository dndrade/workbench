# syntax=docker/dockerfile:1.7

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode
ARG BUN_VERSION=1.3.14

ENV BUN_INSTALL=/home/${USERNAME}/.bun
ENV PATH=/home/${USERNAME}/.bun/bin:${PATH}
ENV SHELL=/usr/bin/fish

USER root

COPY docker/base/scripts/ /tmp/workbench/

RUN chmod 0755 /tmp/workbench/*.sh \
	&& /tmp/workbench/install-tools.sh \
	&& /tmp/workbench/install-fish.sh "${USERNAME}" \
	&& /tmp/workbench/install-bun.sh "${USERNAME}" "${BUN_VERSION}" \
	&& rm -rf /tmp/workbench

COPY docker/base/config/fish/ \
	/home/${USERNAME}/.config/fish/

COPY docker/base/config/git/gitconfig \
	/home/${USERNAME}/.gitconfig

RUN chown -R "${USERNAME}:${USERNAME}" \
		"/home/${USERNAME}/.config" \
		"/home/${USERNAME}/.gitconfig" \
		"/home/${USERNAME}/.bun"

USER ${USERNAME}

WORKDIR /workspaces
