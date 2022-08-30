# Install Obsidian AppImage
def "mysetup desktop obsidian" [] {
  "Install Obsidian"
  fetch (github latestdownload obsidianmd/obsidian-releases amd64.deb).0 -o /tmp/obsidian.deb
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y /tmp/obsidian.deb | ignore
}
