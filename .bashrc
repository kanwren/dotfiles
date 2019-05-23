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

xkcd() {
  if [[ "$1" =~ rand(om)? ]]; then
    xdg-open "https://c.xkcd.com/random/comic/" &>/dev/null
  else
    xdg-open "https://xkcd.com/$1/" &>/dev/null
  fi
}

google() {
  query="$(echo $1 | sed -e 's/ /%20/g')"
  xdg-open "https://google.com/search?q=$query" &>/dev/null
}

alias puzzle='xdg-open "https://lichess.org/training" >/dev/null'

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias l1='ls -1'
alias lsd='ls -d */'

alias xsc='xclip -sel clip'

alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias .7='cd ../../../../../../..'
alias .8='cd ../../../../../../../..'
alias .9='cd ../../../../../../../../..'

# Screen settings

# xrandr --output $(xrandr | grep " connected" | cut -f1 -d " ") --brightness 1
brightness() {
  if [[ $1 =~ 0\.[2-9][0-9]*|1(\.0+)? ]]; then
    echo "Brightness: $1"
    for disp in $(xrandr | grep " connected" | cut -f1 -d " "); do
      echo "Setting $disp..."
      xrandr --output $disp --brightness $1
    done
  else
    echo "Invalid brightness; enter a value between 0.2 and 1.0"
  fi
}

configure_night_mode() {
  for disp in $(xrandr | grep " connected" | cut -f1 -d " "); do
    echo "Configuring $disp..."
    xrandr --output $disp --gamma $1 --brightness $2
  done
}

night() {
  case $1 in
    off) configure_night_mode 1:1:1 1.0 ;;
    *) configure_night_mode 1:1:0.5 0.7 ;;
  esac
}
