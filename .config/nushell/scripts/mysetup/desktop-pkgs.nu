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

  let onedrive = (do -i {dpkg-query -W -f='${Status}' onedrive } | complete)
  if ( ($onedrive).exit_code == 1 ) {
    echo "Installing Onedrive"
    wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/onedrive.gpg | ignore
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list | ignore
    sudo apt-get -qq -y update | ignore
    sudo apt-get -qq -y install onedrive | ignore
    echo 'To authorize computer, execute: onedrive'
    echo 'Initial synchro: onedrive --synchronize --download-only --single-directory Share'
  }

  let franz = (do -i {dpkg-query -W -f='${Status}' franz } | complete)
  if ( ($franz).exit_code == 1 ) {
    echo "Installing Franz"
    fetch (github latestdownload meetfranz/franz amd64.deb).0 -o /tmp/franz.deb
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install /tmp/franz.deb | ignore
  } 
 
}
