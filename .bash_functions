#!/bin/bash

function getcommands() {
  awk '{a[$2]++}END{for(i in a){print a[i] " " i}}'
}

function bak() {
  cp -a $1{,.`date "+%y%m%d%H%M"`}
}

function separator(){
  printf '%*s\n' $(tput cols) '' | tr ' ' -;
}

function ssl-showcert(){
  openssl s_client -connect $1:443 -servername $1
}

mkcd() {
  command mkdir -p "$1" && cd "$1";
}

colissimo() {
  xdg-open https://www.laposte.fr/outils/suivre-vos-envois?code=${1}
}

function ffcutvideo() {
  if [[ ! $# -eq 3 ]]; then
    echo "Erreur:  donnez le nom de la vidéo et le temps de début et de fin à garder, ie:"
    echo "Exemple: ffcutvideo somevideo.mp4 0:1:30 0:0:4"
  else
    ffmpeg -i ${1} -ss ${2} -to ${3} -vcodec copy -acodec copy cut-"$1"
  fi
}

function meteo(){
  curl http://wttr.in/${1}?lang=fr ;

  curl http://v2.wttr.in/${1}?lang=fr ;
}

function sms_free(){
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

function vbextpack() {
  version=$(virtualbox --help | head -n 1 | awk '{print $NF} ' | sed s/v//g)
  wget  https://download.virtualbox.org/virtualbox/${version}/Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack
  sudo VBoxManage extpack install --replace \
    --accept-license=--accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c \
    /tmp/Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack
  }

function vbguestadd() {
  echo "Install virtualbox extensions"
  echo "Veuillez monter le cd des guest additions dans la VM"
  read
  if [[ ! -f /media/cdrom0/VBoxLinuxAdditions.run ]];then
    sudo mount /dev/sr0 /media/crdom0
  fi
  sudo sh /media/cdrom0/VBoxLinuxAdditions.run --nox11
  sudo usermod -aG vboxsf $USER
}

function vbconfig() {
  VM=`vboxmanage list vms | awk '{print $1}' | sed s/\"//g | fzf`

  vboxmanage modifyvm ${VM} --clipboard-mode bidirectional
  vboxmanage modifyvm ${VM} --draganddrop bidirectional
  vboxmanage modifyvm ${VM} --firmware efi
  vboxmanage modifyvm ${VM} --vram 256
  VBoxManage modifyvm ${VM} --cpus 4
  VBoxManage modifyvm ${VM} --pae on
  VBoxManage modifyvm ${VM} --nested-hw-virt on
  VBoxManage modifyvm ${VM} --memory 4096
  VBoxManage modifyvm ${VM} --audio none
  VBoxManage sharedfolder add ${VM} --name vmshare --hostpath ~/Dropbox/vmshare --automount
 }

function postinstall_00-conf() {
  echo "Desactivation accès root"
  sudo passwd -l root

  echo "désactivation maj cache man-db"
  sudo systemctl mask man-db.service
  sudo systemctl daemon-reload

  echo "désactivation veille automatique"
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

  echo "Installation Parefeu"
  if ! dpkg-query -W -f='${Status}' firewalld  | grep "ok installed"
  then
    sudo apt update
    sudo apt install -y firewalld
    sudo firewall-cmd --set-default-zone=drop
    sudo firewall-cmd --runtime-to-permanent
    sudo firewall-cmd --reload
  fi
}

function renameuser(){
  if [[ ! $# -eq 2 ]]; then
    echo "Erreur:  donnez l'ancien et le nouveau login, ie:"
    echo "Exemple:  renameuser old new"
    return 1
  fi
  OLD=$1
  NEW=$2

  sudo usermod -l ${NEW} ${OLD}
  sudo usermod -d /home/${NEW} -m ${NEW}
  sudo groupmod -n ${NEW} ${OLD}
  id ${NEW}
}

function postinstall_10-base() {
  if [[ ! -f "/etc/apt/sources.list.d/backports.list" ]]; then
    echo "activation des dépôts backports"
    echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/backports.list
    sudo apt update && sudo apt upgrade -y
  fi
  PKGS="sudo vim git curl tig rdiff-backup backupninja gdebi pdftk rsync \
    firmware-linux-free firmware-linux-nonfree firmware-linux \
    python-ldap ldap-utils mariadb-client newsbeuter \
    kitty kitty-terminfo pipx python3-venv python3-pil \
    atool unrar odt2txt w3m linuxbrew-wrapper poppler-utils ranger libssl-dev pkg-config"

  sudo apt -y install ${PKGS}

  PIPX_PKGS="gita updog pywal mdcat youtube-dl"
  echo "Installation logiciels pipx: ${PIPX_PKGS}"
  for PKG in ${PIPX_PKGS}; do
    if [[ ! -d "${HOME}/.local/pipx/venvs/${PKG}" ]];then
      pipx install ${PKG}
    fi
  done
  if [[ ! -f "/etc/bash_completion.d/gita" ]]; then
    sudo wget https://raw.githubusercontent.com/nosarthur/gita/master/.gita-completion.bash -O /etc/bash_completion.d/gita
  fi
  PATH=${HOME}/.local/bin:${PATH}

  echo "Installing Nerd Fonts"
  if [[ ! -d "${HOME}/.local/share/fonts/NerdFonts" ]];then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts && \
      cd /tmp/nerd-fonts && \
      ./install.sh JetBrainsMono
  fi

  echo "Installation nix"
  if [[ ! -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]];then
    curl -L https://nixos.org/nix/install | sh
  fi
  . ${HOME}/.nix-profile/etc/profile.d/nix.sh
  NIX_PKGS="bash-completion bat broot direnv docker-compose dust exa ffmpegthumbnailer \
    fzf icdiff miller navi neovim starship viu xsv \
    yadm zoxide"

  sudo -E sh -c 'echo 1 > /proc/sys/vm/overcommit_memory' # probleme memoire
  echo "Installation pkg nix"
  for PKG in ${NIX_PKGS}; do
    if [[ ! -L "${HOME}/.nix-profile/bin/${PKG}" ]]; then
      nix-env -i ${PKG}
    fi
  done
  if [[ ! -f "${HOME}/.config/broot/launcher/bash/br" ]];then
    broot --install
  fi

  echo "Installation ASDF"
  if [[ ! -d "${HOME}/.asdf" ]];then

    git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf && cd ${HOME}/.asdf && git checkout "$(git describe --abbrev=0 --tags)"
  fi
  echo "Installation plugins ASDF"
  . "${HOME}/.asdf/asdf.sh"
  ASDF_PLUGINS="golang rust"
  for PLUGIN in ${ASDF_PLUGINS}; do
    asdf plugin add ${PLUGIN}
    asdf install ${PLUGIN} latest
    echo "ASDF: Installation version"
    asdf global ${PLUGIN} `asdf latest ${PLUGIN}`
  done

  echo "Installation pkgs cargo"
  CARGO_PKGS="tealdeer"
  for PKG in ${CARGO_PKGS}; do
    cargo install ${PKG}
  done
  asdf reshim rust

  if [[ ! -d ${HOME}/dev/src/github.com/humboldtux ]]; then
    mkdir -p ${HOME}/{bin,dev,pkg} \
             ${HOME}/dev/src/github.com/humboldtux
  fi

  echo "Installation Docker"
  if ! dpkg-query -W -f='${Status}' docker-ce  | grep "ok installed"
  then
    curl -sSL https://get.docker.com/ | sh
  fi
  sudo usermod -aG docker $USER
  sudo systemctl enable docker
  sudo systemctl restart docker

  echo "Installation sysdig"
  if ! dpkg-query -W -f='${Status}' sysdig  | grep "ok installed"
  then
    curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash
  fi

  echo "Installation Powershell"
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  if [[ ! -f "/etc/apt/sources.list.d/microsoft.list" ]]; then
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-buster-prod buster main" > /etc/apt/sources.list.d/microsoft.list'
  fi
  sudo apt update && sudo apt install -y powershell

  if [[ ! -d "${HOME}/.config/yadm/repo.git" ]];then
    YADM="https://github.com/humboldtux/dotfiles.git"
    yadm upgrade ${YADM} || yadm clone ${YADM}
  fi
  if [[ ! -d "${HOME}/.cache/wal" ]];then
    wal --theme vscode
  fi

  vim_plug
}

function postinstall_30-desktop() {
  install_browsers

  install_burpsuite

  PKGS="sudo ssh-askpass-gnome xclip keychain icedtea-netx network-manager-pptp-gnome \
    libcanberra-gtk-module calibre libreoffice \
    remmina-plugin-nx remmina-plugin-telepathy remmina-common \
    remmina-plugin-exec remmina-plugin-xdmcp \
    remmina-plugin-spice remmina-plugin-rdp remmina-plugin-secret remmina-plugin-vnc remmina \
    nautilus-extension-burner nautilus-filename-repairer nautilus-scripts-manager"

  sudo apt -y install ${PKGS}
}

function postinstall_40-multimedia() {
  echo "Installation depo multimedia"
  if ! dpkg-query -W -f='${Status}' deb-multimedia-keyring  | grep "ok installed"
  then
    wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb
    sudo dpkg -i deb-multimedia-keyring_2016.8.1_all.deb
    sudo apt update && sudo apt upgrade -y
  fi
  if [[ ! -f "/etc/apt/sources.list.d/deb-multimedia.list" ]]; then
    echo "deb http://www.deb-multimedia.org buster main non-free" | sudo tee -a /etc/apt/sources.list.d/deb-multimedia.list
    echo "deb http://www.deb-multimedia.org buster-backports main" | sudo tee -a /etc/apt/sources.list.d/deb-multimedia.list
    sudo apt update && sudo apt upgrade -y
  fi

  echo "Installation Multimedia"
  sudo apt install -y vlc vlc-plugin-base libnfs13 handbrake* libdvdnav4 libdvd-pkg libdvdread4
  sudo dpkg-reconfigure libdvd-pkg
}

function postinstall_70-pentest() {
  PKGS_GO="github.com/ffuf/ffuf github.com/OWASP/Amass/v3/... github.com/tomnomnom/httprobe \
    github.com/0xsha/GoLinkFinder github.com/003random/getJS"
  for PKG in ${PKGS_GO}; do
    go get -v ${PKG}
  done

  PIPX_PKGS="sublist3r dnsgen"
  echo "Installation logiciels pipx: ${PIPX_PKGS}"
  for PKG in ${PIPX_PKGS}; do
    if [[ ! -d "${HOME}/.local/pipx/venvs/${PKG}" ]];then
      pipx install ${PKG}
    fi
  done

  echo "Installation pkgs cargo"
  CARGO_PKGS="lychee"
  for PKG in ${CARGO_PKGS}; do
    cargo install ${PKG}
  done
  asdf reshim rust

  DEB_PKGS="nmap"
  sudo apt install -y ${DEB_PKGS}

  if [[ ! -d /usr/share/seclists ]]; then
    sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists
  fi
}

function install_browsers() {
  echo "Installation Chrome"
  if ! dpkg-query -W -f='${Status}' google-chrome-stable  | grep "ok installed"
  then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo gdebi /tmp/chrome.deb
  fi

  echo "Installation Tor"
  sudo apt install -y torbrowser-launcher && torbrowser-launcher
}

function install_teams() {
  echo "Installation Teams"
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  if [[ ! -f "/etc/apt/sources.list.d/teams.list" ]]; then
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
    sudo apt update
  fi
  sudo apt install -y teams
  [[ -f ${HOME}/.config/autostart/teams.desktop ]] && rm {HOME}/.config/autostart/teams.desktop
}

function vim_plug() {
  echo "Installation plugin nvim"
  if [[ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
      --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          nvim --headless +PlugUpgrade +qall
        else
          nvim --headless +PlugUpgrade +qall
          nvim --headless +PlugUpdate +qall
  fi
}

function install_vbox() {
  echo "Installation VirtualBox"
  sudo apt-get install -y dkms
  if [[ ! -f "/etc/apt/sources.list.d/virtualbox.list" ]];then
    echo "deb http://download.virtualbox.org/virtualbox/debian buster contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
  fi
  if ! dpkg-query -W -f='${Status}' dropbox  | grep "ok installed"
  then
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt update && sudo apt install -y virtualbox-6.1
    sudo usermod -aG vboxusers $USER
    vbextpack
  fi
  if [[ ! -f "/etc/bash_completion.d/VBoxManage" ]];then
    sudo wget https://raw.githubusercontent.com/gryf/vboxmanage-bash-completion/master/VBoxManage -O /etc/bash_completion.d/VBoxManage
  fi
}

function install_dropbox() {
  echo "Installation Dropbox"
  echo "Récupérez un backup du dossier ${HOME}/Dropbox, pusi appuyez sur une touche"
  read
  if [[ ! -f /etc/apt/sources.list.d/dropbox.list ]];then
    echo "deb [arch=amd64] http://linux.dropbox.com/debian buster main" | sudo tee -a /etc/apt/sources.list.d/dropbox.list
  fi

  if ! dpkg-query -W -f='${Status}' dropbox  | grep "ok installed"
  then
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys FC918B335044912E
    gpg --export --armor FC918B335044912E | sudo apt-key add
    sudo apt update && sudo apt install -y dropbox
    dropbox start -i
    dropbox autostart y
    dropbox status
    dropbox filestatus
  fi
}

function install_tviewer() {
  if [[ ! -d /opt/teamviewer ]];then
    wget https://download.teamviewer.com/download/linux/teamviewer_amd64.tar.xz -O /tmp/teamviewer_amd64.tar.xz
    sudo tar xf /tmp/teamviewer_amd64.tar.xz -C /opt
    sudo chown -R benben /opt/teamviewer*

    /opt/teamviewer/tv-setup checklibs #Vérifier les dépendances QT
    sudo apt-get install libdbus-1-3 libqt5gui5 libqt5widgets5 libqt5qml5 libqt5quick5 \
      libqt5webkit5 libqt5x11extras5 qml-module-qtquick2 qml-module-qtquick-controls \
      qml-module-qtquick-dialogs qml-module-qtquick-window2 qml-module-qtquick-layouts

    echo "exécuter une fois ./teamviewer pour valider que tout fonctionne avant de créer les fichiers de conf"
    /opt/teamviewer/teamviewer
    read
    sudo ln -s /opt/teamviewer/teamviewer.desktop /usr/share/applications/.
    sudo ln -s /opt/teamviewer/tv_bin/desktop/teamviewer_256.png /opt/teamviewer/tv_bin/desktop/teamviewer.png
  fi
}

function install_burpsuite() {
  if [[ ! -d "/opt/BurpSuiteCommunity" && ! -d "${HOME}/BurpSuiteCommunity" ]]; then
    wget "https://portswigger.net/burp/releases/download?product=community&type=Linux" -O /tmp/burp.sh
    sh /tmp/burp.sh
    sudo chown root:root ${HOME}/BurpSuiteCommunity/burpbrowser/*/chrome-sandbox
    sudo chmod u+s ${HOME}/BurpSuiteCommunity/burpbrowser/*/chrome-sandbox
  fi
}

function preseed_create() {
  # https://framagit.org/fiat-tux/hat-softwares/preseed-creator
  if [[ ! $# -eq 4 ]]; then
    echo "Erreur:  donnez en paramètre l'iso, le fichier preseed et les menu installer de isolinux et grub, ie:"
    echo "Exemple:  preseed_test Test-Preseed ~/Téléchargements/firmware-10.8.0-amd64-netinst.iso ~/.config/preseed/preseed.cfg ~/.config/preseed/isolinux.cfg ~/.config/preseed/grub.cfg"
    return 1
  fi

  INPUT=$1
  PRESEED=$2
  ISOLINUX=$3
  GRUB=$4
  if [[ ! -f ${INPUT} ]]; then
    echo "Fichier ISO ${INPUT} introuvable"
    return
  fi

  if [[ ! -f ${PRESEED} ]]; then
    echo "Fichier preseed ${PRESEED} introuvable"
    return
  fi

  if [[ ! -f ${ISOLINUX} ]]; then
    echo "Fichier menu ${ISOLINUX} introuvable"
    return
  fi

  if [[ ! -f ${GRUB} ]]; then
    echo "Fichier menu ${GRUB} introuvable"
    return
  fi

  LOOPDIR="/mnt/loopdir"
  OUTPUT="/tmp/debian-nonofficial-preseed.iso"
  WORKDIR="/tmp/preseed"

  sudo -l > /dev/null
  echo -ne 'Mounting ${INPUT} in ${MOUNT}               [===========>                  ](40%)\r'
  sudo mkdir ${LOOPDIR} -p
  sudo mount -o loop ${INPUT} ${LOOPDIR}
  if [ $? -ne 0 ]; then
    echo "Error while mounting the ISO ${INPUT} in ${LOOPDIR}. Aborting"
    return 2
  fi

  mkdir -p ${WORKDIR}/cd
  echo -ne 'Extracting ISO image                        [==============>               ](50%)\r'
  rsync -a -H --exclude=TRANS.TBL ${LOOPDIR}/ ${WORKDIR}/cd
  sudo chmod -R u+rw ${WORKDIR}/cd

  echo -ne 'Umounting ${INPUT}${MOUNT}                  [=================>            ](60%)\r'
  sudo umount ${LOOPDIR}

  echo -ne 'Hacking initrd                              [====================>         ](70%)\r'
  mkdir -p ${WORKDIR}/irmod
  cd ${WORKDIR}/irmod
  gzip -d < ${WORKDIR}/cd/install.amd/initrd.gz | cpio --extract --make-directories --no-absolute-filenames 2>/dev/null
  sleep 5
  if [ $? -ne 0 ]
  then
    echo "Error while getting ${WORKDIR}/cd/install.amd/initrd.gz content. Aborting"
    return 1
  fi

  cp $PRESEED ${WORKDIR}/irmod/preseed.cfg
  find . | cpio -H newc --create 2>/dev/null | gzip -9 > ${WORKDIR}/cd/install.amd/initrd.gz 2>/dev/null
  if [ $? -ne 0 ]
  then
    echo "Error while putting new content into ${WORKDIR}/cd/install.amd/initrd.gz. Aborting"
    return 1
  fi

  cd ${WORKDIR}
  rm -rf ${WORKDIR}/irmod

  echo -ne 'Custom isolinux menu                       [=======================>      ](75%)\r'
  sed -i 's/include gtk.cfg//g' ${WORKDIR}/cd/isolinux/menu.cfg 2>/dev/null
  mv ${WORKDIR}/cd/isolinux/menu.cfg ${WORKDIR}/cd/isolinux/original.cfg
  if [ $? -ne 0 ]
  then
    echo "Error while renaming ${WORKDIR}/cd/isolinux/menu.cfg Aborting"
    return 1
  fi

  cp ${ISOLINUX} ${WORKDIR}/cd/isolinux/menu.cfg
  if [ $? -ne 0 ]
  then
    echo "Error while copying menu installer ${ISOLINUX} to ${WORKDIR}/cd/isolinux/menu.cfg Aborting"
    return 1
  fi

  echo -ne 'Custom grub menu                           [=======================>      ](80%)\r'
  cp ${GRUB} ${WORKDIR}/cd/boot/grub/grub.cfg
  if [ $? -ne 0 ]
  then
    echo "Error while copying menu installer ${GRUB} to ${WORKDIR}/cd/boot/grub/grub.cfg Aborting"
    return 1
  fi

  echo -ne 'Fixing md5sums                              [========================>     ](85%)\r'
  cd ${WORKDIR}/cd
  md5sum `find -follow -type f 2>/dev/null` > md5sum.txt 2>/dev/null
  if [ $? -ne 0 ]
  then
    echo "Error while fixing md5sums. Aborting"
    return 1
  fi

  cd ${WORKDIR}
  echo -ne 'Creating preseeded ISO image                [==========================>   ](90%)\r'
  genisoimage -quiet -o ${OUTPUT} -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ${WORKDIR}/cd > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "Error while creating the preseeded ISO image. Aborting"
    return 1
  fi

  echo -ne 'Preseeded ISO image created                 [==============================](100%)\r'
  echo -e "\ndeleting ${WORKDIR}/cd"
  rm -rf "${WORKDIR}/cd"
  echo -e "\n\nYour preseeded ISO image is located at $OUTPUT"
}

preseed_test() {
  if [[ ! $# -eq 5 ]]; then
    echo "Erreur:  donnez en paramètre la vm de test, l'iso, le fichier preseed et le menu installer de isolinux et grub, ie:"
    echo "Exemple:  preseed_create firmware-10.8.0-amd64-netinst.iso preseed.cfg menu.cfg"
    return 1
  fi

 VM=$1
 INPUT=$2
 PRESEED=$3
 ISOLINUX=$4
 GRUB=$5
 OUTPUT="/tmp/debian-nonofficial-preseed.iso"

 vboxmanage controlvm ${VM} poweroff
 vboxmanage storageattach ${VM} --storagectl IDE --port 1 --device 0 --type dvddrive --medium "emptydrive"
 sudo rm -f ${OUTPUT}

 preseed_create ${INPUT} ${PRESEED} ${ISOLINUX} ${GRUB} || return

 vboxmanage storageattach ${VM} --storagectl IDE --port 1 --device 0 --type dvddrive --medium ${OUTPUT} && vboxmanage startvm ${VM}
}
