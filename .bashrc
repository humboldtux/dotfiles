#!/bin/bash

# If not running interactively, don't do anything
[ "$PS1" = "" ] && return

if [ -d "$HOME/.local/binaries" ]; then
  PATH="$HOME/.local/binaries:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

eval "$(ssh-agent -s)" >/dev/null

. /usr/share/bash-completion/bash_completion

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME"/.cargo/env
else
  PATH="$HOME/.cargo/bin:$PATH"
fi

#HISTORY
#export HISTCONTROL="${HISTCONTROL:-ignorespace:erasedups}"
export HISTCONTROL="${HISTCONTROL:-ignorespace}"
export HISTSIZE=10000
shopt -s histappend #append to bash_history if Terminal quits
# Recherche avec UpArrow/DownArrow
if [ -t 1 ]; then
  bind '"[A":history-search-backward'
  bind '"[B":history-search-forward'
fi

eval "$(starship init bash)"
eval "$(zoxide init bash)"

[[ $- == *i* ]] && [ -f /usr/share/bash-completion/completions/fzf ] && source /usr/share/bash-completion/completions/fzf
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

export RANGER_LOAD_DEFAULT_RC=FALSE

if [ -x "$(command -v direnv)" ]; then
  eval "$(direnv hook bash)"
fi

if [ -f "$HOME"/.config/broot/launcher/bash/br ]; then
  source "$HOME"/.config/broot/launcher/bash/br
fi

export EDITOR="nvim"

#export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/dev"
PATH="$GOPATH/bin:$PATH"

export BAT_THEME="Nord"

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

PATH="$HOME/dev/src/github.com/humboldtux/scripts":$PATH
PATH="$HOME/dev/src/github.com/humboldtux/scripts-priv":$PATH
export PATH

if [ -x "$(command -v navi)" ]; then
  eval "$(navi widget bash)"
  export NAVI_PATH="$HOME/dev/src/github.com/humboldtux/cheats-priv:$HOME/dev/src/github.com/humboldtux/cheats:$HOME/.local/share/navi/cheats"
fi

if [ -x "$(command -v zellij)" ]; then
  eval "$(zellij setup --generate-completion bash)"
fi

if [ -x "$(command -v procs)" ]; then
  eval "$(procs --gen-completion-out bash)"
fi

if [ -x "$(command -v cscli)" ]; then
  eval "$(cscli completion bash)"
fi

if [ -f "$HOME/.govc_env" ]; then
  source "$HOME"/.govc_env
fi

# shellcheck disable=SC1090
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

# Charger tous les scripts du dossier ~/.bashrc.d
if [ -d "$HOME/.bashrc.d" ]; then
  for fichier in "$HOME"/.bashrc.d/*.sh; do
    [ -r "$fichier" ] && . "$fichier"
  done
fi
