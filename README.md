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

Releases are driven by [release-please](https://github.com/googleapis/release-please), not a manual git tag. Merging a PR to `main` updates a standing, bot-maintained **Release PR** with the computed version and changelog. Merging *that* PR is what creates the tag and publishes:

```
merge PR(s) to main -> release-please updates the Release PR -> you review and merge it -> tag + publish
```

Image and template release independently, each with their own Release PR and tag prefix (`workbench-base-v...`, `template/svelte-v...`) -- see Versioning below.

Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/) -- release-please computes the version bump directly from these (`fix:` -> patch, `feat:` -> minor, `feat!:`/`BREAKING CHANGE:` -> major), so a mislabelled commit produces the wrong release, not just an unflagged one.

</details>

<details>

<summary><strong>Versioning</strong></summary>

**Image** (`workbench-base`, `workbench-svelte`) releases as its own component. Merging its Release PR creates a tag like `workbench-base-v0.2.0` and publishes the floating Docker tags:

```
0.2.0
0.2
0
```

Consumer projects should reference:

```
ghcr.io/dndrade/workbench-svelte:0
```

**Template** (`workbench/svelte`) releases independently, with its own tag (`template/svelte-v0.1.1`) and its own version history. The `version` field in `src/svelte/devcontainer-template.json` is bumped automatically by release-please when the template component releases -- no manual edit needed.

Consumer projects should reference:

```
ghcr.io/dndrade/workbench/svelte:<version>
```

</details>