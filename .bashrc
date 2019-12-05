# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

[ -e ~/.nix-profile/etc/profile.d/nix.sh ] && . ~/.nix-profile/etc/profile.d/nix.sh

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
  *) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# +--------------------+
# | User configuration |
# +--------------------+

export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi
# Make C-l clear the screen in insert mode
bind -m vi-insert "\C-l":clear-screen

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

alias svim='sudoedit'

# Handy ls shortcuts
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias l1='ls -1'
alias lsd='ls -d */'

alias xc='xclip -sel clip'
# Copy last command
alias copylast="fc -ln -1 | awk '{\$1=\$1}1' | xclip -sel clip"

alias cleantex='rm *.aux *.log'

alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias .7='cd ../../../../../../..'
alias .8='cd ../../../../../../../..'
alias .9='cd ../../../../../../../../..'

# Replace default handle that suggest apt-getting everything
command_not_found_handle() {
  echo "$1: command not found"
}

# File for when private aliases/functions are needed
[ -f ~/local.bashrc ] && source ~/local.bashrc
