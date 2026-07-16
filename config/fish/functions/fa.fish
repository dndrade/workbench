function __fa_alias_desc --description 'Read the command represented by a Fish alias'
    set -l name $argv[1]

    if not functions -q $name
        return 1
    end

    set -l body (functions $name)
    set -l signature (string match -r -- "^function .+--description ['\"]alias .+['\"]" $body)

    if test (count $signature) -eq 0
        return 1
    end

    set -l desc
    if string match -q "*--description 'alias *" -- $signature[1]
        set desc (string match -r -- "--description 'alias [^']+'" $signature[1])
        set desc (string replace -r -- "^--description 'alias " "" $desc)
        set desc (string replace -r -- "'\$" "" $desc)
    else if string match -q '*--description "alias *' -- $signature[1]
        set desc (string match -r -- '--description "alias [^"]+"' $signature[1])
        set desc (string replace -r -- '^--description "alias ' "" $desc)
        set desc (string replace -r -- '"$' "" $desc)
    end

    if test -z "$desc"
        return 1
    end

    string replace -r -- "^$name=" "" $desc
end

function __fa_section --description 'Print an alias section when aliases exist'
    set -l title $argv[1]
    set -l names $argv[2..-1]
    set -l lines

    for name in $names
        set -l desc (__fa_alias_desc $name)
        if test -n "$desc"
            set -a lines "  "(set_color yellow)$name(set_color normal)" → $desc"
        end
    end

    if test (count $lines) -eq 0
        return
    end

    echo
    echo (set_color brcyan)$title(set_color normal)
    printf '%s\n' $lines
end

function fa --description 'List Workbench aliases by category'
    echo (set_color cyan)'Fish aliases'(set_color normal)

    __fa_section 'Navigation / listing' l la ll
    __fa_section 'Git' gst ga gau gaa gcm gca gsw gswc gl gcl gd gds gls gt gr grs gpl gps gpt gbr gbrd gbs gup ghp ghpr
    __fa_section 'GitHub CLI' ghcl ghu ghprc ghprv
    __fa_section 'Filesystem safety' rm cp mv
    __fa_section 'System information' df du
    __fa_section 'Shell' reload e vi
end
