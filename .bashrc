#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# asdf version manager configi
# https://github.com/asdf-vm/asdf
# https://asdf-vm.com/#/core-manage-asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash # completions

# due to some wierd but, tmuxp won't run without
# this https://github.com/tmux-python/tmuxp/issues/405
source ~/.bash_locale

