# Install base pipx packages
def "mysetup base pipx" [] {

  sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install pipx | ignore

  let pkgs = [
    pywhat
    reindent
    streamlink
  ]

  $pkgs | each { || pipx install $in }

}
