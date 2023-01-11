# open /etc/passwd | lines | parse "{username}:{password}:{uid}:{gid}:{comment}:{home}:{shell}" | get username | str collect ' '

def "nu-complete username-uid" [] {
  open /etc/passwd
  | lines
  | parse "{username}:{password}:{uid}:{gid}:{comment}:{home}:{shell}"
  | get username uid
  | flatten
}

def common-username-uid [] { ["root", "daemon", "mail", "0", "1", "8" ] }

# Sous-commande password de getent pour Nushell
def "nu-getent passwd" [
  #key?: string@"nu-complete username" # Clé à rechercher
  key?: string@"nu-complete username-uid" # Clé à rechercher
] {
  let data = (open /etc/passwd | lines | parse "{username}:{password}:{uid}:{gid}:{comment}:{home}:{shell}")
    if ($key|is-empty) {
      $data
    } else {
      $data | where username == $key or uid == $key
    }
}

def "nu-complete group" [] {
  open /etc/group
  | lines
  | parse "{group}:{password}:{gid}:{members}"
  | get group
}

# Sous-commande group de getent pour Nushell
def "nu-getent group" [
  key?: string@"nu-complete group" #Clé à rechercher 
] {
  let data = (open /etc/group | lines | parse "{group}:{password}:{gid}:{members}")
    if ($key|is-empty) {
      $data
    } else {
      $data | where group == $key or gid == $key
    }
}

let version_getent = '0.1.0'

# Commande getent pour Nushell
def "nu-getent" [
  --version, -v # Afficher la version
] {
  if $version {
    echo $version_getent
  }
}
