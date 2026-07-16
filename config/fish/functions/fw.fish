function __fw_item --description 'Print a workflow helper when it exists'
    set -l name $argv[1]
    set -l desc $argv[2..-1]

    if functions -q $name
        echo "  "(set_color yellow)$name(set_color normal)" → $desc"
    end
end

function __fw_section --description 'Print a workflow section'
    echo
    echo (set_color brcyan)$argv[1](set_color normal)
end

function fw --description 'List Workbench workflow helpers'
    echo (set_color cyan)'Fish workflows'(set_color normal)

    __fw_section 'Project inspection'
    __fw_item peek 'show a compact tree from the current Git project root'
    __fw_item git-tree 'show tracked files as a tree'

    __fw_section 'Git'
    __fw_item gcleanb 'delete local branches whose upstream is gone'
    __fw_item gitwho 'show repository identity, remotes, and signing configuration'
    __fw_item gitid 'set this repository Git identity'

    __fw_section 'GitHub'
    __fw_item ghcreate 'create a GitHub repository from the current project'

    __fw_section 'SSH'
    __fw_item sshwho 'inspect forwarded SSH-agent availability and identities'

    __fw_section 'Inspector'
    __fw_item fa 'list aliases'
    __fw_item fw 'list workflow helpers'
end
