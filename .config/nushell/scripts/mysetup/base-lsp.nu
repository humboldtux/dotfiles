# Install LSP servers
def "mysetup base lsp" [] {
  
  let bindir = $"($env.HOME)/.local/binaries"

  echo "Install bash"
  sudo npm i -g bash-language-server | ignore

  echo "Install Go"
  cd /tmp
  go install golang.org/x/tools/gopls@latest
  
  echo "Install html"
  sudo npm i -g vscode-langservers-extracted | ignore
  
  echo "Install Python"
  pipx install 'python-lsp-server[all]'
  
  echo "Install rust-analyzer"
  fetch (github latestdownload  rust-lang/rust-analyzer x86_64-unknown-linux-gnu).0 -o /tmp/rust-analyzer.gz
  gunzip -q -c /tmp/rust-analyzer.gz | save $"($bindir)/rust-analyzer"
  
  echo "Install Taplo"
  fetch (github latestdownload tamasfe/taplo full-x86_64-unknown-linux-gnu).0 -o /tmp/taplo.tgz
  tar --extract -C $bindir --file /tmp/taplo.tgz taplo

  echo "Install lldb"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y lldb | ignore
  sudo ln -s /usr/lib/llvm-14/bin/lldb-vscode /usr/bin/lldb-vscode

  chmod +x  ~/.local/binaries/*

}
