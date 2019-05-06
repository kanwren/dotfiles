export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi

bak() {
    if [ $# -eq 1 ]; then
        if [ -f "$1" ]; then
            cp "$1" "$1.bak"
            echo "Copied $1 to $1.bak"
        else
            echo "error: cannot find file $1" >&2
        fi
    else
        echo "error: expected 1 argument, got $#" >&2
    fi
}

lsd() {
    for d in */; do
        echo $d
    done
}
