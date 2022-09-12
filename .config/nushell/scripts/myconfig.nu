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

source aliases.nu
source functions.nu
