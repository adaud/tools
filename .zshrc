#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# ALIASES
alias h='history 25'
alias j='jobs -l'
alias ls='ls -LSG'
alias la='ls -a'
alias lf='ls -FA'
alias ll='ls -lA'
alias rm='rm -i'
alias less='less -XR'
alias grep='grep --color=always'
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

# add timestamps to history & write out to the history file immediately
setopt extended_history
setopt share_history
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=2000

# set variables
export GREP_COLOR=33 #yellow

# set path
#export PATH=$PATH:/usr/sbin

