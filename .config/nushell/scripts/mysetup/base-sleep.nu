# Disable sleep
def "mysetup base sleep" [] { 
  echo "Disable sleep"
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
}
