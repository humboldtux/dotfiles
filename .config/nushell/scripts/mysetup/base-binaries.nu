# Install base binaries
def "mysetup base binaries" [] {

  let bindir = $"($env.HOME)/.local/binaries"
  mkdir $bindir
  let-env PATH = ($env.PATH | split row (char esep) | prepend $bindir)

  echo "Installing Wezterm"
  fetch (github latestdownload  wez/wezterm Debian11.deb).0 -o /tmp/wezterm.deb
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y /tmp/wezterm.deb | ignore

  echo "Installing Bandwhich"
  fetch (github latestdownload imsnif/bandwhich x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/bandwhich.tgz
  tar --extract -C $bindir --file /tmp/bandwhich.tgz bandwhich

  echo "Installing Bottom"
  fetch (github latestdownload  ClementTsang/bottom x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/bottom.tgz
  tar --extract -C $bindir --file /tmp/bottom.tgz btm

  echo "Installing Broot"
  let version = (github latestversion Canop/broot | sed 's/broot v//g')
  wget -q $"https://github.com/Canop/broot/releases/latest/download/broot_($version).zip" -O /tmp/broot.zip
  unzip -q -o -p /tmp/broot.zip x86_64-unknown-linux-musl/broot | save $"($bindir)/broot"
  chmod +x $"($bindir)/broot"
  mkdir ~/.config/broot/launcher/bash
  broot --print-shell-function bash | save ~/.config/broot/launcher/bash/br
  broot --set-install-state installed

  echo "Installing Carapace"
  fetch (github latestdownload rsteube/carapace-bin Linux_x86_64.tar.gz).0 -o /tmp/carapace.tgz
  tar --extract -C $bindir --file /tmp/carapace.tgz carapace

  echo "Installing Delta"
  fetch (github latestdownload dandavison/delta x86_64-unknown-linux-gnu).0 -o /tmp/delta.tgz
  tar --extract --strip-components 1 -C $bindir --file /tmp/delta.tgz --wildcards --no-anchored '*delta'

  echo "Installing Gum"
  fetch (github latestdownload charmbracelet/gum linux_x86_64.tar.gz$).0 -o /tmp/gum.tgz
  tar --extract -C $bindir --file /tmp/gum.tgz gum
 
  echo "Installing Helix"
  wget -q (github latestdownload  helix-editor/helix AppImage$).0 -O $"($bindir)/hx"

  echo "Installing Kondo"
  curl -sSL https://github.com/tbillington/kondo/releases/latest/download/kondo-x86_64-unknown-linux-gnu.tar.gz -o /tmp/kondo.tgz
  tar --extract -C $bindir --file /tmp/kondo.tgz kondo

  echo "Installing LazyGit"
  fetch (github latestdownload  jesseduffield/lazygit Linux_x86_64).0 -o /tmp/lazygit.tgz
  tar --extract -C $bindir --file /tmp/lazygit.tgz lazygit

  echo "Installing Navi"
  fetch (github latestdownload denisidoro/navi x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/navi.tgz
  tar --extract -C $bindir --file /tmp/navi.tgz navi
 
  echo "Installing ncdu"
  curl -sSL https://dev.yorhel.nl/download/ncdu-2.1.2-linux-x86_64.tar.gz -o /tmp/ncdu.tgz
  tar --extract -C $bindir --file /tmp/ncdu.tgz ncdu

  echo "Installing Neovim"
  wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O $"($bindir)/nvim"

  echo "Installing Nushell"
  fetch (github latestdownload nushell/nushell x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/nushell.tgz
  tar --extract -C $bindir --file /tmp/nushell.tgz nu

  echo "Installing qrcp"
  fetch (github latestdownload claudiodangelis/qrcp linux_x86_64.tar.gz).0 -o /tmp/qrcp.tgz
  tar --extract -C $bindir --file /tmp/qrcp.tgz qrcp

  echo "Installing Starship"
  wget -q https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz -O /tmp/starship.tgz
  tar --extract -C $bindir --file /tmp/starship.tgz starship

  echo "Installing Topgrade"
  fetch (github latestdownload  r-darwish/topgrade x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/topgrade.tgz
  tar --extract -C $bindir --file /tmp/topgrade.tgz topgrade

  echo "Installing up"
  curl -sSL https://github.com/akavel/up/releases/latest/download/up -o $"($bindir)/up"

  echo "Installing Viu"
  wget -q https://github.com/atanunq/viu/releases/latest/download/viu -O $"($bindir)/viu"

  echo "Installing Zellij"
  curl -sSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz -o /tmp/zellij.tgz
  tar --extract -C $bindir --file /tmp/zellij.tgz zellij

  echo "Installing Zoxide"
  fetch (github latestdownload ajeetdsouza/zoxide x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/zoxide.tgz
  tar --extract -C $bindir --file /tmp/zoxide.tgz zoxide

  chmod u+x $"($bindir)/*"

}
