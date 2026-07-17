## Summary



## Related issue

Closes #

## Checklist

- [ ] Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`fix:`, `feat:`, `feat!:` for breaking) -- release-please computes the version bump from these
- [ ] Touches `src/**`, `test/**`, `.github/actions/smoke-test-template/**`, and/or `.github/workflows/{validate,publish}-template.yaml`
- [ ] No manual version bump needed -- release-please updates `version` in `src/svelte/devcontainer-template.json` itself when this component releases
- [ ] `validate-template.yaml` passes
- [ ] Not an image-only change (use the "Image Change" PR template for that)
