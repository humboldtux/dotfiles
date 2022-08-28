def "nu-complete virtualbox-vms" [] {
    vboxmanage list vms | tr -d '"' | lines | parse "{name} {uid}" | get name
}

# Install VirtualBox
def "virtualbox install" [] {
  sudo chown root:root /opt

  echo "Installing Deps"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y dkms build-essential linux-headers-amd64 linux-kbuild-* | ignore

  let version = (fetch https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT | str trim)
  let url = $"https://download.virtualbox.org/virtualbox/($version)"

  let md5sum = $"($url)/MD5SUMS"
  let installer = (fetch $md5sum | grep Linux_amd64.run | awk '{print $2}' | sed -e s/*//g | str trim)

  echo $"Downloading /tmp/($installer)"
  wget -q $"($url)/($installer)" -O $"/tmp/($installer)"

  echo $"Installing /tmp/($installer)"
  sudo sh $"/tmp/($installer)" --nox11 install | ignore

  #sudo rcvboxdrv setup

  #bash $"($env.HOME)/dev/src/github.com/humboldtux/scripts/vbextpack"
  virtualbox extpackinstall

  sudo usermod -aG vboxusers $env.USER

  sudo wget -q https://raw.githubusercontent.com/gryf/vboxmanage-bash-completion/master/VBoxManage -O /etc/bash_completion.d/VBoxManage
}

# Install extension pack for current VB installation
def "virtualbox extpackinstall" [] {
  let version = (virtualbox --help | head -n 1 | awk '{print $NF} ' | sed s/v//g | str trim)

  echo "Downloading extpack"
  wget -q $"https://download.virtualbox.org/virtualbox/$(version)/Oracle_VM_VirtualBox_Extension_Pack-($version).vbox-extpack" -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-$(version).vbox-extpack

  echo "Installing extpack"
  sudo VBoxManage extpack install --replace --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c $"/tmp/Oracle_VM_VirtualBox_Extension_Pack-($version).vbox-extpack"
}

# Install guest additions on VM
def "virtualbox guestaddition" [] {
  sudo mount /dev/sr0 /media/cdrom0
  sudo sh /media/cdrom0/VBoxLinuxAdditions.run --nox11
  sudo usermod -aG vboxsf $env.USER
}

# Configure vm settings
def "virtualbox vmconfig" [
  vm: string@"nu-complete virtualbox-vms"
] {
  vboxmanage modifyvm $vm --clipboard-mode bidirectional
  vboxmanage modifyvm $vm --draganddrop bidirectional
  vboxmanage modifyvm $vm --firmware efi
  vboxmanage modifyvm $vm --vram 256
  VBoxManage modifyvm $vm --cpus 4
  VBoxManage modifyvm $vm --pae on
  VBoxManage modifyvm $vm --nested-hw-virt on
  VBoxManage modifyvm $vm --memory 8192
  VBoxManage modifyvm $vm --audio none
  VBoxManage sharedfolder add $vm --name vmshare --hostpath ~/Dropbox/vmshare --automount
}
