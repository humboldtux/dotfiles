# Install base binaries
def "mysetup base binaries" [
  --filter(-f) # don't select any choice
] {

  let bindir = $"($env.HOME)/.local/binaries"
  mkdir $bindir
  let-env PATH = ($env.PATH | split row (char esep) | prepend $bindir)

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
    zellij
    zoxide
  ]

  let choices = if ( not ( $"($bindir)/gum" | path exists) ) {
    $binaries
  } else if $filter {
    ($binaries | to text | gum filter --no-limit | lines)
  } else {
    ($binaries | to text | gum choose --no-limit --selected ($binaries | str join ',') | lines)
  }

  if ('wezterm' in $choices) {
    echo "Installing Wezterm"
    curl -sSL (github latestdownload  wez/wezterm Debian11.deb).0 -o /tmp/wezterm.deb
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y /tmp/wezterm.deb | ignore
  }

  if ('bandwhich' in $choices) {
    echo "Installing Bandwhich"
    curl -sSL (github latestdownload imsnif/bandwhich x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/bandwhich.tgz
    tar --extract -C $bindir --file /tmp/bandwhich.tgz bandwhich
  }

  if ('bottom' in $choices) {
    echo "Installing Bottom"
    curl -sSL (github latestdownload  ClementTsang/bottom x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/bottom.tgz
    tar --extract -C $bindir --file /tmp/bottom.tgz btm
  }

  if ('broot' in $choices) {
    echo "Installing Broot"
    let version = (github latestversion Canop/broot | sed 's/broot v//g')
    curl -sSL (github latestdownload  Canop/broot zip).0 -o /tmp/broot.zip
    unzip -q -o -p /tmp/broot.zip x86_64-unknown-linux-musl/broot | save -f $"($bindir)/broot"
    chmod +x $"($bindir)/broot"
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
    tar --extract -C $bindir --file /tmp/gum.tgz gum
  }
 
  if ('kondo' in $choices) {
    echo "Installing Kondo"
    curl -sSL https://github.com/tbillington/kondo/releases/latest/download/kondo-x86_64-unknown-linux-gnu.tar.gz -o /tmp/kondo.tgz
    tar --extract -C $bindir --file /tmp/kondo.tgz kondo
  }

  if ('lazygit' in $choices) {
    echo "Installing LazyGit"
    curl -sSL (github latestdownload  jesseduffield/lazygit Linux_x86_64).0 -o /tmp/lazygit.tgz
    tar --extract -C $bindir --file /tmp/lazygit.tgz lazygit
  }

  if ('navi' in $choices) {
    echo "Installing Navi"
    curl -sSL (github latestdownload denisidoro/navi x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/navi.tgz
    tar --extract -C $bindir --file /tmp/navi.tgz navi
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
    curl -sSL (github latestdownload nushell/nushell x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/nushell.tgz
    tar --extract --strip-components 1 -C $bindir --file /tmp/nushell.tgz --wildcards --no-anchored '*nu'
  }

  if ('starship' in $choices) {
    echo "Installing Starship"
    wget -q https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz -O /tmp/starship.tgz
    tar --extract -C $bindir --file /tmp/starship.tgz starship ; starship init nu | save -f ~/.cache/starship/init.nu
  }

  if ('topgrade' in $choices) {
    echo "Installing Topgrade"
    curl -sSL (github latestdownload topgrade-rs/topgrade x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/topgrade.tgz
    tar --extract -C $bindir --file /tmp/topgrade.tgz topgrade
  }

  if ('up' in $choices) {
    echo "Installing up"
    curl -sSL https://github.com/akavel/up/releases/latest/download/up -o $"($bindir)/up"
  }

  if ('viu' in $choices) {
    echo "Installing Viu"
    wget -q https://github.com/atanunq/viu/releases/latest/download/viu -O $"($bindir)/viu"
  }

  if ('zellij' in $choices) {
    echo "Installing Zellij"
    curl -sSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz -o /tmp/zellij.tgz
    tar --extract -C $bindir --file /tmp/zellij.tgz zellij
  }

  if ('zoxide' in $choices) {
    echo "Installing Zoxide"
    curl -sSL (github latestdownload ajeetdsouza/zoxide x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/zoxide.tgz
    tar --extract -C $bindir --file /tmp/zoxide.tgz zoxide ; zoxide init nushell | save -f ~/.zoxide.nu
  }

  chmod u+x $"($bindir)/*"

}
