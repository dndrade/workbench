# ─────────────────────────────────────────────
# Workbench Environment
# Shared environment variables for all projects.
# Do not place secrets or personal credentials here.
# ─────────────────────────────────────────────

# Bun
set -gx BUN_INSTALL "$HOME/.bun"

if test -d "$BUN_INSTALL/bin"
    fish_add_path --global "$BUN_INSTALL/bin"
end

# User-local binaries
if test -d "$HOME/.local/bin"
    fish_add_path --global "$HOME/.local/bin"
end

# Preferred CLI tools
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less

# Optional non-secret runtime identity.
# These may be supplied by:
#   • Host environment
#   • Dotfiles
#   • Container-specific overrides
#
# Leave empty by default.

set -q WORKBENCH_GIT_NAME
or set -gx WORKBENCH_GIT_NAME ""

set -q WORKBENCH_GIT_EMAIL
or set -gx WORKBENCH_GIT_EMAIL ""

set -q WORKBENCH_GITHUB_USER
or set -gx WORKBENCH_GITHUB_USER ""