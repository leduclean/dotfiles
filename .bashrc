# ~/.bashrc — Bash configuration file for interactive non-login shells

## Early exit for non-interactive shells
case $- in
    *i*) ;;
      *) return;;
esac
##  Environment variables
export EDITOR=nvim
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000

##  Shell options
shopt -s histappend
shopt -s checkwinsize
# shopt -s globstar  # uncomment if needed

## History + Lesspipe + Chroot
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

## Prompt configuration
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

## Source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

## Programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Brew init
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# export PATH="$HOME/.local/bin:$PATH"


## Tools Init (fzf, zoxide, git-completion, oh-my-posh, cargo, brew)

# Oh my posh
eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/themes/catppuccin_mocha.omp.json)"

# Git completion
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/bash/git-completion.bash" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/bash/git-completion.bash"
. "$HOME/.cargo/env"

# Zoxide
export PATH="/home/linuxbrew/.linuxbrew/opt/zoxide/bin:$PATH"
eval "$(zoxide init bash)"

# FZF
eval "$(fzf --bash)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border"
# Tmux conf

export FZF_TMUX_OPTS="-p90%,70% "
# Setup fzf previews
export FZF_CTRL_T_OPTS='
  --preview="[ -d {} ] && tree -C {} | head -100 || bat --style=numbers --color=always --line-range=:500 {}"
'
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview='tree -C {}'"

# Launch Vs code on a specific folder
codefzf() {
  local folder
  folder=$(
    fd --type l --type d --hidden --strip-cwd-prefix \
       --exclude .git --exclude node_modules \
    | fzf \
      --preview="tree -C {} | head -100" \
      --preview-window=right:60%
  ) || return

  if [[ -n $folder ]]; then
    code "$folder" && cd "$folder"
  fi
}

PS1=$'\x01'"$PS1"
