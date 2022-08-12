# open /etc/passwd | lines | parse "{login}:{password}:{uid}:{gid}:{gecos}:{homedir}:{shell}" | get login | str collect ' '

def "nu-complete login-uid" [] {
  open /etc/passwd
  | lines
  | parse "{login}:{password}:{uid}:{gid}:{gecos}:{homedir}:{shell}"
  | get login uid
  | flatten
}

def common-login-uid [] { ["root", "daemon", "mail", "0", "1", "8" ] }

# Sous-commande password de getent pour Nushell
def "nu-getent passwd" [
  #key?: string@"nu-complete login" # Clé à rechercher
  key?: string@"nu-complete login-uid" # Clé à rechercher
] {
  let data = (open /etc/passwd | lines | parse "{login}:{password}:{uid}:{gid}:{gecos}:{homedir}:{shell}")
    if ($key|empty?) {
      $data
    } else {
      $data | where login == $key or uid == $key
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
    if ($key|empty?) {
      $data
    } else {
      $data | where group == $key or gid == $key
    }
}

let version_getent = '0.1.0'

# Commande getent pour Nushell
def "nu-getent" [
  --version, (-v) # Afficher la version
] {
  if $version {
    echo $version_getent
  }
}
