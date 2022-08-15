#!/bin/bash

alias topgrade='topgrade --disable remotes'

#alias ls='exa'
#alias la='exa -a --color=always --group-directories-first'
alias lx='exa -la --color=always --group-directories-first'
#alias liso='exa --time-style full-iso'

alias grep='grep --color=auto'
export GREP_COLOR='1;33'

alias ag='ag --smart-case --pager="less -MIRFX"'

alias pbcopy="xclip -selection clipboard -r"
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

alias bcat="batcat -pp"
alias bless="batcat -p"

alias ccat='highlight -O ansi'

alias diff='diff --color'

alias streamlink='streamlink  --default-stream best --retry-streams 1 --retry-max 0 --retry-open 100'

alias youtube_dl_sub='youtube-dl --all-subs --write-auto-sub'
alias youtube_dl_most="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"
alias yt_sub='yt-dlp --all-subs --write-auto-sub'
alias yt_most="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"

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

alias icat="wezterm imgcat"

alias cat_img="viu"

alias cat_odt="odt2txt"

alias cat_md="mdcat"

alias cat_pdf="pdftotext -l 10 -nopgbrk -q --"

alias cat_csv='mlr --icsv --opprint cat'

alias chef_shell_init='[[ -z ${GEM_ROOT+x} ]] && eval "$(chef shell-init bash)"'

alias ssh_kitty='kitty +kitten ssh'

alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'

alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

alias my_nmap='sudo nmap -n -P0 -sS -sU -T5 --max-retries=0 --max-rtt-timeout=1000ms     --host-timeout=100 --min-rate=16000     --min-parallelism=4000 --max-parallelism=8000 --max-scan-delay=1ms     --min-hostgroup=1 --max-rate=65536 -p-'

alias battery='upower -i $(upower -e | grep "BAT")'

alias vpn_dsi='/opt/cisco/anyconnect/bin/vpn'
alias vpn_dsi_c='/opt/cisco/anyconnect/bin/vpn connect open.unice.fr'
alias vpn_dsi_d='/opt/cisco/anyconnect/bin/vpn disconnect'

alias jsonify='python -m json.tool'
