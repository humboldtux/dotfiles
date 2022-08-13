# Install guest additions on VM
def "virtualbox guestaddition" [] {
  sudo mount /dev/sr0 /media/cdrom0
  sudo sh /media/cdrom0/VBoxLinuxAdditions.run --nox11
  sudo usermod -aG vboxsf $env.USER
}
