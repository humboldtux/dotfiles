# Install base binaries
def "mysetup base binaries" [
  --filter(-f) # don't select any choice
] {

  let bindir = $"($env.HOME)/.local/binaries"
  mkdir $bindir
  $env.PATH = ($env.PATH | split row (char esep) | prepend $bindir)

  let binaries = [
    bandwhich
    bottom
    broot
    carapace
    delta
    dust
    gum
    navi
    ncdu
    neovim
    nushell
    starship
    topgrade
    up
    viu
    wezterm
    wtf
    xq
    yazi
    zellij
    zoxide
  ]

  let choices = if $filter {
    ($binaries | to text | gum filter --no-limit | lines)
  } else {
    ($binaries | to text | gum choose --no-limit --selected ($binaries | str join ',') | lines)
  }

  if ('wezterm' in $choices) {
    echo "Installing Wezterm"
    curl -sSL (github latestdownload  wez/wezterm Ubuntu22.04.deb).0 -o /tmp/wezterm.deb
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y /tmp/wezterm.deb | ignore
    wget -q https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo -O ~/.terminfo
  }

  if ('bandwhich' in $choices) {
    echo "Installing Bandwhich"
    cargo binstall bandwhich
  }

  if ('bottom' in $choices) {
    echo "Installing Bottom"
    cargo binstall bottom
  }

  if ('broot' in $choices) {
    echo "Installing Broot"
    cargo binstall broot
    mkdir ~/.config/broot/launcher/bash
    broot --print-shell-function bash | save -f ~/.config/broot/launcher/bash/br
    broot --set-install-state installed
  }

  if ('carapace' in $choices) {
    echo "Installing Carapace"
    curl -sSL (github latestdownload rsteube/carapace-bin bin_linux_amd64.tar.gz).0 -o /tmp/carapace.tgz
    tar --extract -C $bindir --file /tmp/carapace.tgz carapace
  }

  if ('delta' in $choices) {
    echo "Installing Delta"
    curl -sSL (github latestdownload dandavison/delta x86_64-unknown-linux-gnu).0 -o /tmp/delta.tgz
    tar --extract --strip-components 1 -C $bindir --file /tmp/delta.tgz --wildcards --no-anchored '*delta'
  }

  if ('dust' in $choices) {
    echo "Installing Dust"
    curl -sSL (github latestdownload bootandy/dust x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/dust.tgz
    tar --extract --strip-components 1 -C $bindir --file /tmp/dust.tgz --wildcards --no-anchored '*dust'
  }

  if ('gum' in $choices) {
    echo "Installing Gum"
    curl -sSL (github latestdownload charmbracelet/gum Linux_x86_64.tar.gz$).0 -o /tmp/gum.tgz
    tar --extract --strip-components 1 -C $bindir --file /tmp/gum.tgz --wildcards --no-anchored '*gum'
  }
 
  if ('kondo' in $choices) {
    echo "Installing Kondo"
    cargo binstall kondo
  }

  if ('lazygit' in $choices) {
    echo "Installing LazyGit"
    curl -sSL (github latestdownload  jesseduffield/lazygit Linux_x86_64).0 -o /tmp/lazygit.tgz
    tar --extract -C $bindir --file /tmp/lazygit.tgz lazygit
  }

  if ('navi' in $choices) {
    echo "Installing Navi"
    cargo binstall navi
  }
 
  if ('ncdu' in $choices) {
    echo "Installing ncdu"
    curl -sSL https://dev.yorhel.nl/download/ncdu-2.1.2-linux-x86_64.tar.gz -o /tmp/ncdu.tgz
    tar --extract -C $bindir --file /tmp/ncdu.tgz ncdu
  }

  if ('neovim' in $choices) {
    echo "Installing Neovim"
    wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O $"($bindir)/nvim"
  }

  if ('nushell' in $choices) {
    echo "Installing Nushell"
    cargo binstall nu
  }

  if ('starship' in $choices) {
    echo "Installing Starship"
    cargo binstall starship
  }

  if ('topgrade' in $choices) {
    echo "Installing Topgrade"
    cargo binstall topgrade-rs
  }

  if ('up' in $choices) {
    echo "Installing up"
    curl -sSL https://github.com/akavel/up/releases/latest/download/up -o $"($bindir)/up"
  }

  if ('viu' in $choices) {
    echo "Installing Viu"
    cargo binstall viu
  }

  if ('zellij' in $choices) {
    echo "Installing Zellij"
    cargo binstall zellij
  }

  if ('zoxide' in $choices) {
    echo "Installing Zoxide"
    cargo binstall zoxide
  }

  if ('xq' in $choices) {
    echo "Installing xq"
    cargo binstall xq
  }

  if ('yazi' in $choices) {
    echo "Installing yazi filemanager"
    cargo binstall yazi-fm yazi-cli
  }

  if ('wtf' in $choices) {
    echo "Installing wtf"
    curl -sSL (github latestdownload wtfutil/wtf linux_amd64).0 -o /tmp/wtf.tgz
    tar --extract --strip-components 1 -C $bindir --file /tmp/wtf.tgz --wildcards --no-anchored '*wtfutil'
  }

  chmod u+x $"($bindir)/*"

}
