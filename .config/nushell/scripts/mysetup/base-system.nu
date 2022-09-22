# Disable sleep
def "mysetup base system" [] { 
  echo "Disable sleep"
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  
  echo "Install tuned"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y tuned | ignore
  sudo systemctl enable tuned --now
  sudo tuned-adm list
  echo ""
  echo "sudo tuned-adm profile NAME"
}
