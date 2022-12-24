# Install Desktop deb packages
def "mysetup desktop pkgs" [] { 

  let pkgs = [
    calibre
    copyq
    flameshot
    fonts-arphic-ukai
    fonts-arphic-uming
    fonts-ipafont-mincho
    fonts-ipafont-gothic
    fonts-unfonts-core
    freerdp2-x11
    icedtea-netx
    keychain
    libcanberra-gtk-module
    libreoffice
    lightdm-remote-session-freerdp2
    network-manager-pptp-gnome
    okular
    cpu-x
    rdesktop
    ssh-askpass-gnome
    ttf-xfree86-nonfree
    wireshark
    xclip
    zathura
  ]

  sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install $pkgs | ignore

  let franz = (do -i {dpkg-query -W -f='${Status}' franz } | complete)
  if ( ($franz).exit_code == 1 ) {
    echo "Installing Franz"
    curl -sSL (github latestdownload meetfranz/franz amd64.deb).0 -o /tmp/franz.deb
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install /tmp/franz.deb | ignore
  } 
 
}
