#!/bin/bash

function getcommands() {
  awk '{a[$2]++}END{for(i in a){print a[i] " " i}}'
}

function bak() {
  cp -a $1{,.`date "+%y%m%d%H%M"`}
}

function separator() {
  printf '%*s\n' $(tput cols) '' | tr ' ' -;
}

function ssl_showcert() {
  openssl s_client -connect $1:443 -servername $1
}

function mkcd() {
  command mkdir -p "$1" && cd "$1";
}

function ffcutvideo() {
  if [[ ! $# -eq 3 ]]; then
    echo "Erreur:  donnez le nom de la vidéo et le temps de début et de fin à garder, ie:"
    echo "Exemple: ffcutvideo somevideo.mp4 0:1:30 0:0:4"
  else
    ffmpeg -i ${1} -ss ${2} -to ${3} -vcodec copy -acodec copy cut-"$1"
  fi
}

function meteo() {
  curl http://wttr.in/${1}?lang=fr ;

  curl http://v2.wttr.in/${1}?lang=fr ;
}

function sms_free() {
  curl -s -o /dev/null -w "%{http_code}" -I "https://smsapi.free-mobile.fr/sendmsg?user=${USER}&pass=${PASS}&msg=${1}"
}

function cat_pdf() {
  pdftotext -l 10 -nopgbrk -q -- ${1} - | fmt
}

function cat_vid() {
  OUT='/tmp/tmp.jpg'
  ffmpegthumbnailer -i $1 -o $OUT -s 0
  cat-img $OUT
}

function transfer() {
  curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename "$1") | tee /dev/null;
  echo
}

function gita_add() {
  SEARCH="${HOME}/dev/src/github.com/humboldtux"
  FOUNDS=$(find ${SEARCH} -maxdepth 1 -type d | fzf -m)
  gita add ${FOUNDS}
}

function gita_cd() {
  NAME=$(gita ls | awk 'BEGIN{RS=" "}{$1=$1}1' | fzf)
  REPODIR=$(gita ls ${NAME})
  cd ${REPODIR}
}

github_get_latest_version() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

github_get_latest_dwds() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.assets[].browser_download_url'
}

github_get_latest_dwd() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.assets[].browser_download_url' | grep $2
}

github_dld_latest_releases() {
  DWD=$(github_get_latest_dwds $1 | fzf -m)
  echo "downloading ${DWD}"
  wget -nv -P /tmp ${DWD}
}

github_dld_latest_release() {
  DWD=$(github_get_latest_dwd $1 $2)
  echo "downloading ${DWD}"
  wget -nv ${DWD} -O /tmp/$3
}

teatime() {
  if [[ ! $# -eq 1 ]]; then
    echo "Erreur:  donnez le nombre de minutes, ie:"
    echo "Exemple: teatime 5"
    exit 1
  fi
  sleep ${1}m && paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga && notify-send "Tea Time!"
}

nmap_ports() {
  PORTS=`grep ^[0-9] $1 | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
  echo $PORTS | pbcopy
  echo $PORTS
}

my_fix-broken-install () {
  while true; do apt --fix-broken -y install; apt upgrade -y && apt autoremove -y && break;done
}
