# Install Desktop deb packages
def "mysetup desktop pkgs" [] { 

  let pkgs = [
  	calibre
	copyq
	flameshot
	freerdp2-x11
	icedtea-netx
	keychain
	libcanberra-gtk-module
	libreoffice
	lightdm-remote-session-freerdp2
  	network-manager-pptp-gnome
  	okular
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
    wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/onedrive.gpg | ignore
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list | ignore
    sudo apt-get -qq -y update | ignore
    sudo apt-get -qq -y install onedrive | ignore
    echo 'To authorize computer, execute: onedrive'
    echo 'Initial synchro: onedrive --synchronize --download-only --single-directory Share'
  }
}
