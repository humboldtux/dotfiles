#!/bin/bash

alias lsx='exa'
alias l='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias li='exa --icons --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lg='exa -al --git --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias liso='exa --time-style full-iso'

alias grep='grep --color=auto'
export GREP_COLOR='1;33'

alias ag='ag --smart-case --pager="less -MIRFX"'

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

alias topten="history -1000 | getcommands | sort -rn | head"

alias lsps='ps -elf | grep'

alias rsdr='/usr/local/bin/rsync --dry-run --itemize-changes --out-format="%i|%n|" --recursive --update --modify-window=1 --perms \
                   --owner --group --times --links --safe-links --super --one-file-system --human-readable -vv --devices --exclude "*lost+found*"'

alias rs='/usr/local/bin/rsync --info=progress2 --recursive --update --perms --owner --group --modify-window=1 \
                   --times --links --safe-links --super --one-file-system --partial --devices --exclude "*lost+found*" --human-readable'

alias dec2hex='printf "%x\n"'

alias stripr="egrep -v '^[[:space:]]*(#|$)'"

alias vim='nvim'

alias cat="bat -pp"
#alias less="bat -p"

alias tree="exa --tree --level"

alias ccat='highlight -O ansi'

alias diff='diff --color'

alias streamlink='streamlink  --default-stream best --retry-streams 1 --retry-max 0 --retry-open 100'

alias youtube_dl_sub='youtube-dl --all-subs --write-auto-sub'
alias youtube_dl_most="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"

alias obsidian='obsidian --no-sandbox'

alias curl_burp='curl -x 127.0.0.1:8080 -k'

##########Docker#################
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkd="docker run -d -P"
alias dkit="docker run -it -P"
#################################

###########Git###################
alias gd="git diff | vim -R -"
#################################

alias icat="kitty +kitten icat"

alias cat_img="viu"

alias cat_odt="odt2txt"

alias cat_md="mdcat"

alias cat_pdf="pdftotext -l 10 -nopgbrk -q --"

alias csv_cat='mlr --icsv --opprint cat'

alias chef_shell_init='[[ -z ${GEM_ROOT+x} ]] && eval "$(chef shell-init bash)"'

alias ssh_kitty='kitty +kitten ssh'
