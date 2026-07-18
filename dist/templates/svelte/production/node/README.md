# Node production profile

This is the currently wired production profile for SvelteKit applications that use `@sveltejs/adapter-node`.

It is independent from the Workbench development image and from the shared Svelte Dev Container template.

## Assumptions

- Bun manages dependencies.
- `bun.lock` is committed.
- `bun run build` creates `build/`.
- SvelteKit uses `@sveltejs/adapter-node`.
- The generated server reads `HOST` and `PORT`.

## Smoke test

Run from the application root:

```bash
docker compose -f production/node/docker-compose.yaml up --build -d
```

Open port `3000`.

Stop and remove the test container:

```bash
docker compose -f production/node/docker-compose.yaml down
```
