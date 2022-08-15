def "mysetup base binaries" [] {

  let bindir = $"($env.HOME)/.local/binaries"
  mkdir $bindir

  fetch (github latestdownload  ClementTsang/bottom x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/bottom.tgz
  tar --extract -C $bindir --file /tmp/bottom.tgz btm

  fetch (github latestdownload dandavison/delta x86_64-unknown-linux-gnu).0 -o /tmp/delta.tgz
  tar --extract --strip-components 1 -C $bindir --file /tmp/delta.tgz --wildcards --no-anchored '*delta'

  fetch (github latestdownload  nushell/nushell x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/nushell.tgz
  tar --extract -C $bindir --file /tmp/nushell.tgz nu

  fetch (github latestdownload  starship/starship x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/starship.tgz
  tar --extract -C $bindir --file /tmp/starship.tgz starship

  fetch (github latestdownload  r-darwish/topgrade x86_64-unknown-linux-gnu.tar.gz).0 -o /tmp/topgrade.tgz
  tar --extract -C $bindir --file /tmp/topgrade.tgz topgrade

  wget -q https://github.com/atanunq/viu/releases/latest/download/viu -O $"($bindir)/viu"

  fetch (github latestdownload ajeetdsouza/zoxide x86_64-unknown-linux-musl.tar.gz).0 -o /tmp/zoxide.tgz
  tar --extract -C $bindir --file /tmp/zoxide.tgz zoxide

  chmod u+x $"($bindir)/*"

}
