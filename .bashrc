#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# To unbind ctrl-s (ctrl-s more or less just freezes the terminal, its a redundant functionality from ancient times)
stty -ixon

# asdf version manager config
# https://github.com/asdf-vm/asdf
# https://asdf-vm.com/#/core-manage-asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash # completions

# due to some wierd bug, tmuxp won't run without
# this https://github.com/tmux-python/tmuxp/issues/405
source ~/.bash_locale

