#!/bin/bash

#if ls --color -d . &> /dev/null
#then
#  alias ls="ls --color=auto"
#elif ls -G -d . &> /dev/null
#then
#  alias ls='ls -G'        # Compact view, show colors
#fi

# List directory contents
#alias sl=ls
#alias la='ls -AF'       # Compact view, show hidden
#alias ll='ls -al'
#alias l='ls -a'
#alias l1='ls -1'

alias lsx='exa'
alias l='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias li='exa --icons --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lg='exa -al --git --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'

alias grep='grep --color=auto'
export GREP_COLOR='1;33'

alias ag='ag --smart-case --pager="less -MIRFX"'

XCLIP=$(command -v xclip)
[[ $XCLIP ]] && \
alias pbcopy="$XCLIP -selection clipboard" && \
alias pbpaste="$XCLIP -selection clipboard -o"
####
alias topten="history -1000 | getcommands | sort -rn | head"

alias lsps='ps -elf | grep'

alias rsdr='/usr/local/bin/rsync --dry-run --itemize-changes --out-format="%i|%n|" --recursive --update --modify-window=1 --perms \
                   --owner --group --times --links --safe-links --super --one-file-system --human-readable -vv --devices --exclude "*lost+found*"'

alias rs='/usr/local/bin/rsync --info=progress2 --recursive --update --perms --owner --group --modify-window=1 \
                   --times --links --safe-links --super --one-file-system --partial --devices --exclude "*lost+found*" --human-readable'

alias tmlb='tmuxp load base'

alias dec2hex='printf "%x\n"'

alias stripr="egrep -v '^[[:space:]]*(#|$)'"

alias vim='nvim'

alias tree='broot'

alias newsbeuter='newsboat'

#alias grep='rg'

#alias du='dust'

alias cat="bat -pp"
alias less="bat -p"

alias ccat='highlight -O ansi'

alias diff='diff --color'

alias streamlink='streamlink  --default-stream best --retry-streams 1 --retry-max 0 --retry-open 100'

alias youtube-dl-sub='youtube-dl --all-subs --write-auto-sub'
alias youtube-dl-most="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"

alias obsidian='obsidian --no-sandbox'
##########Docker#################
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkd="docker run -d -P"
alias dkit="docker run -it -P"
#################################

###########Git###################
alias gd="git diff | vim -R -"
#################################

alias icat="kitty +kitten icat"

alias cat-img="viu"

alias cat-odt="odt2txt"

alias cat-md="mdcat"

alias cat-pdf="pdftotext -l 10 -nopgbrk -q --"

#############
# CSV

alias csv-cat='mlr --icsv --opprint cat'

alias chef-shell-init='[[ -z ${GEM_ROOT+x} ]] && eval "$(chef shell-init bash)"'
