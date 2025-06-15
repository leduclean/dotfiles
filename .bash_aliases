# ~/.bash_aliases

# ls with colors
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# grep with colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# navigation
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# system
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# misc
alias sob='. ~/.bashrc'
alias c='clear'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'