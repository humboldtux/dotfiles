#Install Teams
def "mysetup desktop teams" [] {
  echo "Install Teams"
  if ( ('/etc/apt/sources.list.d/teams.list' | path type) != file) {
      sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O /etc/apt/trusted.gpg.d/microsoft.asc
      echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" | sudo tee /etc/apt/sources.list.d/teams.list
      sudo apt-get -qq update | ignore
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y teams | ignore
  }

  rm -f $"($env.HOME)/.config/autostart/teams.desktop"
}
