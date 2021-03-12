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

function ssl-showcert() {
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

function cat-pdf() {
  pdftotext -l 10 -nopgbrk -q -- ${1} - | fmt
}

function cat-vid() {
  OUT='/tmp/tmp.jpg'
  ffmpegthumbnailer -i $1 -o $OUT -s 0
  cat-img $OUT
}

function transfer() {
  curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename "$1") | tee /dev/null;
  echo
}

function gita-add() {
  SEARCH="${HOME}/dev/src/github.com/humboldtux"
  FOUNDS=$(find ${SEARCH} -maxdepth 1 -type d | fzf -m)
  gita add ${FOUNDS}
}

function gita-cd() {
  NAME=$(gita ls | awk 'BEGIN{RS=" "}{$1=$1}1' | fzf)
  REPODIR=$(gita ls ${NAME})
  cd ${REPODIR}
}
