# Disable sleep
def "mysetup base system" [] { 
  echo "Disable sleep"
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  
  echo "Disable Gnome Tracker"
  systemctl --user mask tracker-extract-3.service tracker-miner-apps.service | ignore
  systemctl --user mask tracker-miner-fs-control-3.service tracker-miner-rss-3.service tracker-store.service | ignore 
  systemctl --user mask tracker-writeback.service tracker-extract.service tracker-miner-fs-3.service tracker-miner-fs.service | ignore
  systemctl --user mask tracker-miner-rss.service tracker-writeback-3.service tracker-xdg-portal-3.service | ignore
  tracker3 reset -s -r
  
  echo "Install tuned"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y tuned | ignore
  sudo systemctl enable tuned --now
  sudo tuned-adm list
  echo ""
  echo "sudo tuned-adm profile NAME"
}
