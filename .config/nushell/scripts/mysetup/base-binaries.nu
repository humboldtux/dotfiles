def "mysetup base binaries" [] {

  let bindir = $"($env.HOME)/.local/binaries"
  mkdir $bindir

  echo "Installing Bottom"
  fetch (github latestdownload  ClementTsang/bottom x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/bottom.tgz
  tar --extract -C $bindir --file /tmp/bottom.tgz btm

  echo "Installing Delta"
  fetch (github latestdownload dandavison/delta x86_64-unknown-linux-gnu).0 -o /tmp/delta.tgz
  tar --extract --strip-components 1 -C $bindir --file /tmp/delta.tgz --wildcards --no-anchored '*delta'

  echo "Installing Helix"
  wget -q (github latestdownload  helix-editor/helix AppImage$).0 -O $"($bindir)/hx"

  echo "Installing Neovim"
  wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O $"($bindir)/nvim"

  echo "Installing Nushell"
  fetch (github latestdownload  nushell/nushell x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/nushell.tgz
  tar --extract -C $bindir --file /tmp/nushell.tgz nu

  echo "Installing Starship"
  wget -q https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz -O /tmp/starship.tgz
  tar --extract -C $bindir --file /tmp/starship.tgz starship

  echo "Installing Topgrade"
  fetch (github latestdownload  r-darwish/topgrade x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/topgrade.tgz
  tar --extract -C $bindir --file /tmp/topgrade.tgz topgrade

  echo "Installing Viu"
  wget -q https://github.com/atanunq/viu/releases/latest/download/viu -O $"($bindir)/viu"

  echo "Installing Zoxide"
  fetch (github latestdownload ajeetdsouza/zoxide x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/zoxide.tgz
  tar --extract -C $bindir --file /tmp/zoxide.tgz zoxide

  echo "Installing Wezterm"
  fetch (github latestdownload  wez/wezterm Debian11.deb).0 -o /tmp/wezterm.deb
  sudo apt-get install -qq -y /tmp/wezterm.deb | ignore

  chmod u+x $"($bindir)/*"

}