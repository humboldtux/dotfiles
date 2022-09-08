#https://starship.rs/#nushell
mkdir ~/.cache/starship
if ($"($env.HOME)/.local/binaries/starship" | path exists) {
  starship init nu | save ~/.cache/starship/init.nu
}

#https://github.com/ajeetdsouza/zoxide#installation
if ($"($env.HOME)/.local/binaries/zoxide" | path exists) {
  zoxide init nushell | save ~/.zoxide.nu
}
