#!/bin/bash

# ─────────────────────────────
# Shell interactif uniquement
# ─────────────────────────────
[ "$PS1" = "" ] && return

# ─────────────────────────────
# Variables d’environnement
# ─────────────────────────────
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME="Nord"
shopt -s histappend # append to bash_history if Terminal quits
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE="${HISTSIZE}"

# ─────────────────────────────
# Dossiers bin perso dans $PATH
# ─────────────────────────────
if [ -d "$HOME/.local/binaries" ]; then
  PATH="$HOME/.local/binaries:$PATH"
fi

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME"/.cargo/env
else
  PATH="$HOME/.cargo/bin:$PATH"
fi

# Go
# export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/dev"
PATH="$GOPATH/bin:$PATH"

# Scripts perso
PATH="$HOME/dev/src/github.com/humboldtux/scripts:$PATH"
PATH="$HOME/dev/src/github.com/humboldtux/scripts-priv:$PATH"

# Export final du PATH
export PATH

# ─────────────────────────────
# Agents & Env externes
# ─────────────────────────────
# SSH agent (⚠️ voir commentaire dans retour précédent)
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
fi

# GOVC (VMware)
if [ -f "$HOME/.govc_env" ]; then
  source "$HOME"/.govc_env
fi

# ─────────────────────────────
# Autocomplétions
# ─────────────────────────────
. /usr/share/bash-completion/bash_completion

if command -v fzf &>/dev/null; then
  [[ -f /usr/share/bash-completion/completions/fzf ]] && source /usr/share/bash-completion/completions/fzf
  [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && source /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [ -x "$(command -v zellij)" ]; then
  eval "$(zellij setup --generate-completion bash)"
fi

if [ -x "$(command -v cscli)" ]; then
  eval "$(cscli completion bash)"
fi

if ls /opt/vagrant/embedded/gems/gems/vagrant-*/contrib/bash/completion.sh &>/dev/null; then
  . /opt/vagrant/embedded/gems/gems/vagrant-*/contrib/bash/completion.sh
fi

if [ -f "/usr/bin/packer" ]; then
  complete -C /usr/bin/packer packer
fi

if [ -x "$(command -v minikube)" ]; then
  eval "$(minikube completion bash)"
fi

if [ -x "$(command -v kubectl)" ]; then
  eval "$(kubectl completion bash)"
fi

if [ -x "$(command -v faas-cli)" ]; then
  eval "$(faas-cli completion --shell bash)"
fi

# ─────────────────────────────
# Intégrations d’outils externes
# ─────────────────────────────
eval "$(starship init bash)"
eval "$(zoxide init bash)"

if [ -x "$(command -v direnv)" ]; then
  eval "$(direnv hook bash)"
fi

if [ -f "$HOME/.config/broot/launcher/bash/br" ]; then
  source "$HOME/.config/broot/launcher/bash/br"
fi

if [ -x "$(command -v navi)" ]; then
  eval "$(navi widget bash)"
  export NAVI_PATH="$HOME/dev/src/github.com/humboldtux/cheats-priv:$HOME/dev/src/github.com/humboldtux/cheats:$HOME/.local/share/navi/cheats"
fi

# ─────────────────────────────
# Fichiers utilisateur
# ─────────────────────────────
source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

# Scripts personnalisés (si présents)
if [ -d "$HOME/.bashrc.d" ]; then
  for fichier in "$HOME"/.bashrc.d/*.sh; do
    [ -r "$fichier" ] && . "$fichier"
  done
fi

# ─────────────────────────────
# Fonctions perso
# ─────────────────────────────
fzf_zoxide_cd() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --reverse) && cd "$dir"
}
bind -x '"\C-g": fzf_zoxide_cd'
