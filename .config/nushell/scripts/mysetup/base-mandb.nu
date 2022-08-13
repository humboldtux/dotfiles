# Disable man-db
def "mysetup base mandb" [] { 
  echo "Disable man-db cache"
  sudo apt-get -qq -y remove --auto-remove man-db
  sudo systemctl mask man-db.service
  sudo systemctl daemon-reload
}
