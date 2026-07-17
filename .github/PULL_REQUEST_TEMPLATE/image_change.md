## Summary



## Related issue

Closes #

## Checklist

- [ ] Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`fix:`, `feat:`, `feat!:` for breaking) -- release tags are checked against this
- [ ] Touches `docker/**`, `.github/actions/smoke-test/**`, and/or `.github/workflows/{validate,publish}-image.yaml`
- [ ] New/changed `.sh` scripts are executable (`chmod +x`)
- [ ] `validate-image.yaml` passes
- [ ] If this changes an installed tool version (e.g. `BUN_VERSION`), it was changed via the Dockerfile `ARG` default -- tests derive expected values from it automatically
- [ ] Not a template-only change (use the "Template Change" PR template for that)
