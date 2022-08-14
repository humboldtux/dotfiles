# Configure Git
def "mysetup base git" [] { 
  git config --global pull.ff only
  git config --global push.autoSetupRemote true
}
