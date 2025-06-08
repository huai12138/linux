#
# ~/.bashrc
#
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash specific prompt and environment
PS1='\[\e[1;32m\]\h\[\e[0m\] \u:\w\$ '
export LANG=en_US.UTF-8
export VISUAL=vim
export EDITOR=vim
export TERM=xterm-256color

# 加载通用别名
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
