#https://starship.rs/#nushell
source ~/.cache/starship/init.nu

#https://github.com/ajeetdsouza/zoxide#installation
source ~/.zoxide.nu

# https://github.com/nushell/nu_scripts/tree/main/direnv
# https://www.nushell.sh/cookbook/direnv.html
let-env config = {
  hooks: {
    pre_prompt: [{
      code: "
        let direnv = (direnv export json | from json)
        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
        $direnv | load-env
      "
    }]
  }
}

let external_completer = {|spans|
  {
    $spans.0: {carapace $spans.0 nushell $spans | from json } # default
  } | get $spans.0 | each {|it| do $it}
}

let-env config = {
  external_completer: $external_completer
}

source aliases.nu
source functions.nu
