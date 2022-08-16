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
	  nautilus-extension-burner
	  nautilus-filename-repairer
	  nautilus-scripts-manager
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

}
