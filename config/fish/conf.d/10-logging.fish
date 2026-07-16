# Shared output helpers for Workbench functions.

function log_info --description 'Print an informational message'
    echo (set_color blue)'[INFO]'(set_color normal)" $argv"
end

function log_warn --description 'Print a warning message'
    echo (set_color yellow)'[WARN]'(set_color normal)" $argv"
end

function log_error --description 'Print an error message'
    echo (set_color red)'[ERROR]'(set_color normal)" $argv" >&2
end

function log_ok --description 'Print a success message'
    echo (set_color green)'[OK]'(set_color normal)" $argv"
end

function log_start --description 'Print a task-start message'
    echo (set_color cyan)'[START]'(set_color normal)" $argv"
end
