# Disable Wayland
def "mysetup desktop wayland" [] {
  echo "Disable GDM Wayland"
  sudo sed -i 's/#Wayland/Wayland/g' /etc/gdm3/daemon.conf
}
