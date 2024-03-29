# Install base deb packages
def "mysetup base pkgs" [] { 

  let pkgs = [
      atool
      anacron
      apticron
      backupninja
      bat
      build-essential
      clang
      clang-tools
      curl
      detox
      diffoscope-minimal
      direnv
      dkms
      duf
      dos2unix
      docker-clean
      docker-compose
      docker.io
      exa
      fd-find
      ffmpeg
      ffmpegthumbnailer
      firmware-linux
      firmware-linux-free
      firmware-linux-nonfree
      ftp
      fuse3
      fzf
      gdebi
      golang
      git
      gita
      htop
      iftop
      iotop
      iotop-c
      jc
      jq
      kmon
      khal
      ldap-utils
      libproxychains4
      libssl-dev
      libx11-dev
      linux-headers-amd64
      lldb
      lnav
      locate
      lsd
      luarocks
      mariadb-client
      miller
      moreutils
      needrestart
      neofetch
      neovim
      newsboat
      nodejs
      npm
      ntpdate
      nvme-cli
      odt2txt
      openvpn
      pdftk
      pipx
      pkg-config
      poppler-utils
      proxychains4
      putty-tools
      python3-ldap
      python3-pil
      python3-pip
      python3-venv
      ranger
      rdiff-backup
      ripgrep
      rsync
      ruby-dev
      ruby-notify
      rust-all
      samba-common
      shellcheck
      shfmt
      strace
      sudo
      swaks
      tcpdump
      tig
      tre-command
      tshark
      unrar
      unzip
      vim
      w3m
      xorriso
      yadm
      yt-dlp
  ]

  $pkgs | sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install $in | ignore

}
