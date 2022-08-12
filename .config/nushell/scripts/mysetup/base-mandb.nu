# Disable man-db
def "mysetup base mandb" [] { 
  echo "Disable man-db cache"
  sudo apt-get -y remove --auto-remove man-db >/dev/null
  sudo systemctl mask man-db.service
  sudo systemctl daemon-reload
}
