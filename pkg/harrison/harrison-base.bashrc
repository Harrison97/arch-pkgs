#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

GREEN="$(tput setaf 35)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 37)"
RED="$(tput setaf 9)"
MAGENTA="$(tput setaf 13)"
RESET="$(tput sgr0)"
PS1='\[${YELLOW}\]\A \[${RESET}\][\[${GREEN}\]\u\[${RED}\]@\[${MAGENTA}\]\h \[${YELLOW}\]\W\[${RESET}\]]\[${BLUE}\]$(git_branch)
${RESET}\$ '
#PS1='[\u@\h \W]\$ '
#PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]??\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ?\[\033[0m\] '

#screenfetch

#sh ~/.local/share/ranger/bash_automatic_cd.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval $(thefuck --alias)
