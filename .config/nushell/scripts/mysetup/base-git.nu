# Configure Git
def "mysetup base git" [] { 
  git config --global pull.ff only
  git config --global push.autoSetupRemote true

  cd ~/dev/src/github.com/humboldtux/scripts
  git remote set-url origin git@github.com:humboldtux/scripts.git
  gita add  ~/dev/src/github.com/humboldtux/scripts

  if ( not ('~/dev/src/github.com/humboldtux/cheats' | path exists)) {
    git clone -q git@github.com:humboldtux/cheats.git ~/dev/src/github.com/humboldtux/cheats
  }
  gita add ~/dev/src/github.com/humboldtux/cheats

  if ( not ('~/dev/src/github.com/humboldtux/scripts-priv' | path exists)) {
    git clone -q git@github.com:humboldtux/scripts-priv.git ~/dev/src/github.com/humboldtux/scripts-priv
  }
  gita add ~/dev/src/github.com/humboldtux/scripts-priv

  if ( not ('~/dev/src/github.com/humboldtux/cheats-priv' | path exists)) {
    git clone -q git@github.com:humboldtux/cheats-priv.git ~/dev/src/github.com/humboldtux/cheats-priv
  }
  gita add ~/dev/src/github.com/humboldtux/cheats-priv

  yadm remote set-url origin git@github.com:humboldtux/dotfiles.git
}
