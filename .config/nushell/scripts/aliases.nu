alias ll = ls -l

alias nushell_dwd_tgz = wget -O /tmp/nu-latest-release.tgz (http get https://api.github.com/repos/nushell/nushell/releases/latest | get assets | where name =~ x86_64-unknown-linux-gnu.tar.gz$ | get browser_download_url.0)

alias topgrade = ~/.local/binaries/topgrade --disable remotes

alias grep = /usr/bin/grep --color=auto

alias ag = /usr/bin/ag --smart-case --pager = less -MIRFX

alias pbcopy = xclip -selection clipboard -r
alias pbpaste = xclip -selection clipboard -o

alias dec2hex = printf "%x\n"

alias stripr = egrep -v '^[[:space:]]*(#|$)'

alias vim = nvim

alias bcat = bat -pp
alias bless = bat -p
alias ccat = highlight -O ansi

alias diff = /usr/bin/diff --color

alias streamlink = ~/.local/bin/streamlink  --default-stream best --retry-streams 1 --retry-max 0 --retry-open 100

alias youtube_dl_sub = youtube-dl --all-subs --write-auto-sub
alias youtube_dl_most = youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'
alias yt_sub = yt-dlp --all-subs --write-auto-sub
alias yt_most = yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'

alias obsidian = ~/.local/bin/obsidian --no-sandbox

alias curl_burp = curl -x 127.0.0.1:8080 -k

alias dkip = docker inspect --format '{{ .NetworkSettings.IPAddress }}'
alias dkd = docker run -d -P
alias dkit = docker run -it -P

alias icat = wezterm imgcat
alias cat_img = viu
alias cat_odt = odt2txt
alias cat_md = mdcat
alias cat_pdf = pdftotext -l 10 -nopgbrk -q --
alias cat_csv = mlr --icsv --opprint cat

#alias chef_shell_init = [[ -z ${GEM_ROOT+x} ]] && eval "$(chef shell-init bash)"

alias urldecode = python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"

alias urlencode = python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"

alias battery = upower -i (upower -e | grep 'BAT')

alias vpn_dsi = /opt/cisco/anyconnect/bin/vpn
alias vpn_dsi_c = /opt/cisco/anyconnect/bin/vpn connect open.unice.fr
alias vpn_dsi_d = /opt/cisco/anyconnect/bin/vpn disconnect

alias jsonify = python3 -m json.tool

alias mount = (jc mount | from json)

alias onedrive_log = journalctl --user-unit onedrive -q -f
