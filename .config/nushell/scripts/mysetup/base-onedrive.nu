# Configuring OneDrive
def "mysetup base onedrive" [] {

  systemctl --user daemon-reload
  systemctl --user enable onedrive --now
  systemctl --user restart onedrive --now

  onedrive_log

}
