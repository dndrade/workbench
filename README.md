<!-- Logo -->

<div align="center">

<!-- Optional logo -->
<img src="docs/devcontainer.svg" width="140" alt="Devcontainer Icon">


<!-- Menu -->
<!-- &ensp;[<kbd> <br> Overview <br> </kbd>](#overview) 
&ensp;[<kbd> <br> Repository <br> </kbd>](#repository)
&ensp;[<kbd> <br> Usage <br> </kbd>](#usage)  -->

</br>

<!-- Horizontal line -->
---

[![Release](https://img.shields.io/github/v/release/dndrade/workbench)](https://github.com/dndrade/workbench/releases)
[![Container](https://img.shields.io/badge/GHCR-workbench--svelte-blue)](https://github.com/dndrade/workbench/pkgs/container/workbench-svelte)
[![Dev Containers](https://img.shields.io/badge/Dev%20Container-ready-2496ED)](https://containers.dev/)
[![SvelteKit](https://img.shields.io/badge/SvelteKit-supported-FF3E00)](https://kit.svelte.dev/)
[![Bun](https://img.shields.io/badge/Bun-1.x-black)](https://bun.sh/)
[![License](https://img.shields.io/github/license/dndrade/workbench)](./LICENSE)

</div>

<!-- Rest of the README content -->

## Quick Start

Create an empty project folder.

Apply the Svelte Dev Container Template, bring up the container, and scaffold the app with the CLI:

```bash
devcontainer templates apply \
    --workspace-folder . \
    --template-id ghcr.io/{username}/workbench/svelte

devcontainer up --workspace-folder .

devcontainer exec --workspace-folder . -- bunx sv create .
```

<details>

<summary><strong>Using VS Code instead</strong></summary>

Open the empty project folder in VS Code and run **Dev Containers: Add Dev Container Configuration Files...**.

Run **Dev Containers: Reopen in Container**.

In the container's integrated terminal:

```bash
bunx sv create .
```

</details>

---

<details>

<summary><strong>Development</strong></summary>

```bash
bun run dev
```

</details>

<details>

<summary><strong>Production Test</strong></summary>

```bash
docker compose \
    -f production/node/docker-compose.yml \
    up --build -d
```

</details>

<details>

<summary><strong>Releasing (maintainers)</strong></summary>

Publishing a version tag triggers both the image and template publish workflows:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Commit messages should follow [Conventional Commits](https://www.conventionalcommits.org/) -- CI checks the tag's bump size (major/minor/patch) against `fix:`/`feat:`/`feat!:` commits since the last tag and fails on a breaking change tagged as anything less than major.

</details>

<details>

<summary><strong>Versioning</strong></summary>

**Image** (`workbench-base`, `workbench-svelte`) is tied directly to the pushed git tag. Publishing `v1.2.0` creates:

```
1.2.0
1.2
1
```

Consumer projects should reference:

```
ghcr.io/dndrade/workbench-svelte:1
```

**Template** (`workbench/svelte`) is versioned independently via the `version` field in `src/svelte/devcontainer-template.json`. Pushing a git tag does *not* automatically bump it -- update that field before tagging a release that should also publish a new template version. `publish-template.yaml` enforces this: tagging a release that changed `src/**` without bumping `version` fails CI before anything publishes.

Consumer projects should reference:

```
ghcr.io/dndrade/workbench/svelte:<version>
```

</details>