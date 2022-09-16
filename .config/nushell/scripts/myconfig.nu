#https://starship.rs/#nushell
source ~/.cache/starship/init.nu

#https://github.com/ajeetdsouza/zoxide#installation
source ~/.zoxide.nu

let-env config = ( $env.config | update show_banner false )

# https://github.com/nushell/nu_scripts/tree/main/direnv
# https://www.nushell.sh/cookbook/direnv.html

# https://github.com/rsteube/carapace-bin

source aliases.nu
source functions.nu
