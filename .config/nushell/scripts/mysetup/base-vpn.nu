# Install vpn
def "mysetup base vpn" [] {

  if (not ("/etc/apt/sources.list.d/nordvpn.list" | path exists)) {
    sudo wget -q https://repo.nordvpn.com/gpg/nordvpn_public.asc -O /etc/apt/trusted.gpg.d/nordvpn_public.asc
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" | sudo tee /etc/apt/sources.list.d/nordvpn.list
    sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y update
  }

  sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install nordvpn

  echo $"su - ($env.USER)"
  echo '/usr/bin/nordvpn set technology nordlynx'
  echo '/usr/bin/nordvpn login'
  echo '/usr/bin/nordvpn set killswitch on'
}
