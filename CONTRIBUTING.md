# Contributing

Two independent artifacts: the **image** (`docker/`) and the **template** (`src/svelte/`). Most changes touch one or the other.

## Setup

Fork, clone, **Reopen in Container** (root `.devcontainer/devcontainer.json`).

<details>

<summary><strong>Image change</strong> (<code>docker/**</code>)</summary>

- `chmod +x` new/edited `.sh` scripts
- Tool version bump (e.g. Bun) -> edit the Dockerfile `ARG`, tests read it automatically
- `validate-image.yaml` must pass
- Use the **Image Change** PR template

</details>

<details>

<summary><strong>Template change</strong> (<code>src/**</code>, <code>test/**</code>)</summary>

- New template version -> bump `version` in `devcontainer-template.json` manually (tags don't do it)
- `validate-template.yaml` must pass
- Use the **Template Change** PR template

</details>

## Pull requests

Open a matching issue first if none exists. GitHub offers the matching PR template automatically.

## Releasing

Maintainer-only -- see root [README](./README.md).