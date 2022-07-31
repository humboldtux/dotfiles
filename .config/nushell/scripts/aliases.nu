alias ll = ls -l

alias nushell_dwd_tgz = fetch -b -o /tmp/nu-latest-release.tgz (fetch https://api.github.com/repos/nushell/nushell/releases/latest | get assets | where name =~ x86_64-unknown-linux-gnu.tar.gz$ | get browser_download_url.0)
