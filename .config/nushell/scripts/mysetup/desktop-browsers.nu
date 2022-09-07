# Install Browsers
def "mysetup desktop browsers" [] {

  let  chrome = (do -i {dpkg-query -W -f='${Status}' google-chrome-stable } | complete)
  if ( ($chrome).exit_code == 1 ) {
    echo "Install Chrome"
  	wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
	  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y /tmp/chrome.deb | ignore
  }

  let brave = (do -i {dpkg-query -W -f='${Status}' brave-browser } | complete)
  if ( ($brave).exit_code == 1 ) {
    echo "Install Brave"
  	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	  sudo DEBIAN_FRONTEND=noninteractive apt-get update | ignore
	  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y brave-browser | ignore
  }

  let tor = (do -i {dpkg-query -W -f='${Status}' torbrowser-launcher } | complete)
  if ( ($tor).exit_code == 1 ) {
    echo "Install Tor"
	  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y torbrowser-launcher | ignore
    torbrowser-launcher | ignore
  }

  let edge = (do -i {dpkg-query -W -f='${Status}' microsoft-edge-beta } | complete)
  if ( ($edge).exit_code == 1 ) {
    echo "Install Edge"
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | save microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
    sudo rm microsoft.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge-beta.list
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq update | ignore
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install microsoft-edge-beta  | ignore
  }

}
