# Install Nerd Fonts
def "mysetup base nerdfonts" [] { 

  echo "Installing Nerd Fonts"
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y subversion-tools
	mkdir /tmp/nerd-fonts/patched-fonts
	cd /tmp/nerd-fonts/patched-fonts
	svn export https://github.com/ryanoasis/nerd-fonts/trunk/patched-fonts/JetBrainsMono
  cd /tmp/nerd-fonts
	wget -q https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
	bash install.sh JetBrainsMono

}
