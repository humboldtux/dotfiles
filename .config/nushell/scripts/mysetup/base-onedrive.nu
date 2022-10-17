# Installing OneDrive
def "mysetup base onedrive" [] {

  let onedrive = (do -i {dpkg-query -W -f='${Status}' onedrive } | complete)
  if ( ($onedrive).exit_code == 1 ) {
    echo "Installing Onedrive"

    wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/onedrive.gpg | ignore
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_Testing/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list | ignore

    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y update | ignore
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install onedrive | ignore

    echo 'To authorize computer, execute: onedrive'
    echo 'Initial synchro: onedrive --synchronize --download-only --single-directory Share'

  }

  systemctl --user daemon-reload
  systemctl --user enable onedrive --now
  systemctl --user restart onedrive --now

  onedrive_log

}
