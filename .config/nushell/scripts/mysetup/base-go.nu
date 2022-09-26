# Install Base Go tools
def "mysetup base go" [] {
  
  [bin dev pkg] | each {mkdir $"($env.HOME)/($in)"} | ignore
  
  let-env GOPATH = $"($env.HOME)/dev"
  let-env GOBIN = $"($env.HOME)/go/bin"
  
  sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install golang | ignore

  let pkgs = [
	  github.com/akavel/up@latest
	  github.com/claudiodangelis/qrcp@latest
	  github.com/jesseduffield/lazygit@latest
  ]

  echo "Installation go get"
  $pkgs | each { /usr/bin/go install $in }

}
