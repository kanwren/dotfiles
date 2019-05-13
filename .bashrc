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

gw() {
  compiler="${1:-ghc864}"
  packages="${@:2}"
  nix-shell -p "haskell.packages.$compiler.ghcWithPackages (pkgs: with pkgs; [ $packages ])"
}

alias lsd='for d in */; do echo $d; done'
alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."
alias .6="cd ../../../../../.."
alias .7="cd ../../../../../../.."
alias .8="cd ../../../../../../../.."
alias .9="cd ../../../../../../../../.."
