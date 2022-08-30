# Install multimedia apps
def "mysetup desktop multimedia" [] {

  let pkgs = [
  	guvcview
	  handbrake*
	  libdvdnav4
	  libdvd-pkg
	  libdvdread8
	  libnfs13
	  mpv
	  v4l2loopback-dkms
	  v4l-utils
	  vlc
	  vlc-plugin-base
  ]

  echo "Install Multimedia"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $pkgs | ignore
  sudo dpkg-reconfigure libdvd-pkg

  echo "Install songrec"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y build-essential libasound2-dev libgtk-3-dev libssl-dev | ignore
  cargo install songrec | ignore

}
