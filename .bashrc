#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -d "$HOME/dra/bin" ]; then
	PATH="$HOME/dra/bin:$PATH"
fi

if [ -d "$HOME/.local/binaries" ]; then
	PATH="$HOME/.local/binaries:$PATH"
fi

eval "$(ssh-agent -s)" >/dev/null

. /usr/share/bash-completion/bash_completion

if [ -d "$HOME/.nix-profile/" ]; then
	source "$HOME"/.nix-profile/etc/profile.d/nix.sh
	source "$HOME"/.nix-profile/share/bash-completion/bash_completion
fi

if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME"/.cargo/env
fi

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

[[ $- == *i* ]] && [ -f "$HOME/.nix-profile/share/fzf/completion.bash" ] && source "$HOME/.nix-profile/share/fzf/completion.bash"
[[ $- == *i* ]] && [ -f /usr/share/bash-completion/completions/fzf ] && source /usr/share/bash-completion/completions/fzf
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
[ -f "$HOME"/.nix-profile/share/fzf/key-bindings.bash ] && source "$HOME"/.nix-profile/share/fzf/key-bindings.bash

eval "$(starship init bash)"

export RANGER_LOAD_DEFAULT_RC=FALSE

eval "$(direnv hook bash)"

source "$HOME"/.config/broot/launcher/bash/br

export EDITOR="nvim"

#export GOPATH="$HOME/dev"
export GOBIN="$HOME/go/bin"
PATH="$GOBIN:$PATH"

export BAT_THEME="Nord"

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

PATH="$HOME/dev/src/github.com/humboldtux/scripts":$PATH
PATH="$HOME/dev/src/github.com/humboldtux/scripts-priv":$PATH
export PATH

eval "$(navi widget bash)"
export NAVI_PATH="$HOME/dev/src/github.com/humboldtux/cheats-priv:$HOME/dev/src/github.com/humboldtux/cheats:$HOME/.local/share/navi/cheats"

if [ -x "$(command -v zellij)" ]; then
	eval "$(zellij setup --generate-completion bash)"
fi

if [ -x "$(command -v procs)" ]; then
	eval "$(procs --completion-out bash)"
fi

if [ -x "$(command -v cscli)" ]; then
	eval "$(cscli completion bash)"
fi
