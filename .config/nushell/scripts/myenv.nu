#https://starship.rs/#nushell
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu

#https://github.com/ajeetdsouza/zoxide#installation
zoxide init nushell --hook prompt | save ~/.zoxide.nu
