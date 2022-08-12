# Disable root account
def "mysetup base root" [] { 
  echo "Disable root account"
  sudo passwd -l root
}
