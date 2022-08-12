def "mysetup base pipx" [] {

  let pkgs = [
    pywhat
    reindent
    streamlink
  ]

  $pkgs | each { pipx install $in }

}
