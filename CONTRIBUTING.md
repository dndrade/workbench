# Contributing to Workbench

This page outlines the recommended procedure for contributing changes to the Workbench repository.

## Reporting issues

Open an issue using the matching form: **Bug: Image**, **Bug: Template**, or **Feature Request**. Include enough detail to reproduce -- image tag or template version, and how you applied it (CLI or VS Code).

## Contributing code

All contributions must be made using the [GitHub Flow](https://guides.github.com/introduction/flow/) model and reviewed by a maintainer before merging.

### Fork the repository

**You only need to do this once.**

1. Go to the [Workbench repository home page](https://github.com/dndrade/workbench)
2. Click **Fork** (top-right)
3. Select the namespace to fork into -- usually your personal account

### Clone your fork

```bash
git clone https://github.com/<username>/workbench.git
cd workbench
```

### Set up the dev environment

Open the folder in VS Code and **Reopen in Container** (root `.devcontainer/devcontainer.json`).

### Keep your fork up to date

```bash
git remote add upstream https://github.com/dndrade/workbench.git
git fetch upstream
```

### Create a feature branch

```bash
git fetch upstream
git checkout -b my-new-feature upstream/main
```

<details>

<summary><strong>Domain-specific notes</strong> -- expand the one that matches your change</summary>

<details>

<summary>Image change (<code>docker/**</code>)</summary>

- `chmod +x` new/edited `.sh` scripts
- Tool version bump (e.g. Bun) -> edit the Dockerfile `ARG`, tests read it automatically
- `validate-image.yaml` must pass

</details>

<details>

<summary>Template change (<code>src/**</code>, <code>test/**</code>)</summary>

- New template version -> bump `version` in `devcontainer-template.json` manually (tags don't do this)
- `validate-template.yaml` must pass

</details>

</details>

### Commit your changes

Commit small, focused units of work rather than one large commit at the end -- it's easier to review and easier to undo.

Use [Conventional Commits](https://www.conventionalcommits.org/) -- `check-commit-conventions.sh` reads these at tag time to verify the release bump (major/minor/patch) actually matches what changed. A breaking change without a `!` or `BREAKING CHANGE:` footer won't be caught.

```bash
git commit -m "fix: short summary of the change"
git commit -m "feat: short summary of the change"
git commit -m "feat!: short summary of the change"   # breaking change
```

### Push your branch

```bash
git push --set-upstream origin my-new-feature
```

### Open a pull request

GitHub will offer a **Create Pull Request** button on your fork once the branch is pushed. Fill in the title and description -- GitHub will suggest the matching PR template (**Image Change** or **Template Change**) based on what you touched. A maintainer will review from there.

## Releasing

Maintainer-only -- see the **Releasing** section in the root [README](./README.md).

## More information

General GitHub workflow help: [GitHub Guides](https://guides.github.com/).
