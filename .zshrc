export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

if [ ! -d "$ZSH" ] && command -v curl &> /dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --keep-zshrc --unattended
fi

ZSH_THEME="robbyrussell"

# Use case-insensitive completion.
CASE_SENSITIVE="false"

# Don't auto-update
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    history-substring-search
    vi-mode
    safe-paste
    last-working-dir
    command-not-found
    z
    wd
    cp
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

export EDITOR=vim

alias ..="cd .."
alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."
alias .6="cd ../../../../../.."
alias .7="cd ../../../../../../.."
alias .8="cd ../../../../../../../.."
alias .9="cd ../../../../../../../../.."

if [ ! -d "$HOME/.starship" ]; then
    mkdir -p "$HOME/.starship/bin"
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b "$HOME/.starship/bin"
fi
eval "$($HOME/.starship/bin/starship init zsh)"

