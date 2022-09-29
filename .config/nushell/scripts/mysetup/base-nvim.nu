# Install Neovim
def "mysetup base nvim" [] {

  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y luarocks | ignore

  echo "Installing AstroNVIM conf"
  if ( not ('~/.config/nvim' | path exists) ) {
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  }
  if ( not ('~/.config/nvim/lua/user' | path exists) ) {
    git clone git@github.com:humboldtux/astronvim_user.git ~/.config/nvim/lua/user
  }
  gita add ~/.config/nvim ~/.config/nvim/lua/user
  do -i {gita rename nvim astronvim}
  do -i {gita rename user astronvim_user}

  echo "Neovim update"
  nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
  nvim +"TSInstall all"

}
