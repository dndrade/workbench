# SvelteKit + Bun template

Copy the contents of this directory into the root of a SvelteKit application.

## Template boundaries

```text
.devcontainer/
└── shared Svelte + Bun development environment

production/
└── independently selectable production profiles
    └── node/
        └── currently wired adapter-node profile
```

The Dev Container setup does not depend on the production profile. The Node production profile can therefore be changed or supplemented later without rebuilding the shared Workbench development architecture.

## Required application setup

The currently wired Node profile assumes:

- Bun manages dependencies and `bun.lock` is committed.
- SvelteKit uses `@sveltejs/adapter-node`.
- `bun run build` produces `build/`.
- The generated server uses adapter-node's `HOST` and `PORT` environment variables.

Example `svelte.config.js`:

```js
import adapter from '@sveltejs/adapter-node';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

const config = {
	preprocess: vitePreprocess(),
	kit: {
		adapter: adapter()
	}
};

export default config;
```

Recommended `package.json` scripts:

```json
{
	"scripts": {
		"dev": "vite dev --host 0.0.0.0",
		"build": "vite build",
		"preview": "vite preview --host 0.0.0.0",
		"check": "svelte-kit sync && svelte-check --tsconfig ./tsconfig.json",
		"test": "bun test"
	}
}
```

## Development

Open the project in VS Code and run **Dev Containers: Reopen in Container**.

```bash
bun run dev
```

Development is served on port `5173`.

## Node production smoke test

Run from the application root:

```bash
docker compose -f production/node/compose.yaml up --build
```

Open port `3000`.

```bash
docker compose -f production/node/compose.yaml down
```

The production image is built independently from the Workbench development image.
