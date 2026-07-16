# Optional integrations. Nothing here starts background agents or executes project files.

if not status is-interactive
    return
end

# VS Code / Docker may forward SSH_AUTH_SOCK into the container.
# Workbench intentionally does not discover, start, or kill ssh-agent processes.
