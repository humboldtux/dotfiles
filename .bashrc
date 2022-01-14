#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

eval "$(ssh-agent -s)" >/dev/null

. /usr/share/bash-completion/bash_completion

source "$HOME"/.nix-profile/etc/profile.d/nix.sh
source "$HOME"/.nix-profile/share/bash-completion/bash_completion

source "$HOME"/.cargo/env

#HISTORY
export HISTCONTROL="${HISTCONTROL:-ignorespace:erasedups}"
export HISTSIZE=10000
shopt -s histappend #append to bash_history if Terminal quits
# Recherche avec UpArrow/DownArrow
if [ -t 1 ]; then
	bind '"[A":history-search-backward'
	bind '"[B":history-search-forward'
fi
eval "$(zoxide init bash)"

[[ $- == *i* ]] && source "$HOME/.nix-profile/share/fzf/completion.bash"
source "$HOME"/.nix-profile/share/fzf/key-bindings.bash

# wal --theme base16-nord
#(cat ${HOME}/.cache/wal/sequences &)
#source ${HOME}/.cache/wal/colors-tty.sh

eval "$(starship init bash)"

export RANGER_LOAD_DEFAULT_RC=FALSE

eval "$(direnv hook bash)"

#. ${HOME}/.asdf/asdf.sh
#. ${HOME}/.asdf/completions/asdf.bash

source "$HOME"/.config/broot/launcher/bash/br

export EDITOR="nvim"

export GOPATH=$HOME/dev
export GOBIN=$HOME/bin

export BAT_THEME="Nord"

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

PATH="$HOME/dev/src/github.com/humboldtux/scripts":$PATH
PATH="$HOME/dev/src/github.com/humboldtux/scripts-priv":$PATH
export PATH

eval "$(navi widget bash)"
export NAVI_PATH="$HOME/dev/src/github.com/humboldtux/cheats-priv:$HOME/dev/src/github.com/humboldtux/cheats:$HOME/.local/share/navi/cheats"

eval "$(cscli completion bash)"
