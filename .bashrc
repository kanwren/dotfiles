# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Disable path hashing
set +h

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# Append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
  *) ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi
# Make C-l clear the screen in insert mode
bind -m vi-insert "\C-l":clear-screen

alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias .7='cd ../../../../../../..'
alias .8='cd ../../../../../../../..'
alias .9='cd ../../../../../../../../..'

# File for when private aliases/functions are needed
[ -f ~/local.bashrc ] && source ~/local.bashrc
