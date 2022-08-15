# Install CrowdSec
def "mysetup base crowdsec" [] {

  let crowdsec = (do -i {dpkg-query -W -f='${Status}' crowdsec} | complete)
  if ( ($crowdsec).exit_code == 1 ) {

    echo "CrowdSec Installation"
	  curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash | ignore
	  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y crowdsec | ignore

	  sudo sed -i 's/8080/8181/g' /etc/crowdsec/config.yaml /etc/crowdsec/local_api_credentials.yaml
    sudo systemctl restart crowdsec | ignore
	  
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y crowdsec-firewall-bouncer-iptables | ignore
  
  }
}
