# ─────────────────────────────
# Guard : shell interactif uniquement
# ─────────────────────────────
# Plus fiable que PS1 (best practice moderne)
[[ $- != *i* ]] && return

# ─────────────────────────────
# Helpers
# ─────────────────────────────

# Ajout au PATH sans duplication
add_to_path() {
  case ":$PATH:" in
  *":$1:"*) ;;
  *) PATH="$1:$PATH" ;;
  esac
}

# ─────────────────────────────
# Variables d’environnement
# ─────────────────────────────
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME="Nord"

# Historique
shopt -s histappend
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE="$HISTSIZE"

# Go
export GOPATH="$HOME/dev"

# ─────────────────────────────
# PATH
# ─────────────────────────────
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/binaries"
add_to_path "$HOME/bin"
add_to_path "$GOPATH/bin"
add_to_path "$HOME/dev/src/github.com/humboldtux/scripts"
add_to_path "$HOME/dev/src/github.com/humboldtux/scripts-priv"

# Cargo
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
else
  add_to_path "$HOME/.cargo/bin"
fi

export PATH

# ─────────────────────────────
# SSH Agent (robuste)
# ─────────────────────────────
export SSH_ENV="$HOME/.ssh/agent.env"

if [ -f "$SSH_ENV" ]; then
  source "$SSH_ENV" >/dev/null
fi

if ! pgrep -u "$USER" ssh-agent >/dev/null; then
  ssh-agent >"$SSH_ENV"
  source "$SSH_ENV" >/dev/null
fi

# ─────────────────────────────
# Environnements externes
# ─────────────────────────────
[ -f "$HOME/.govc_env" ] && source "$HOME/.govc_env"

# ─────────────────────────────
# Bash completion (safe load)
# ─────────────────────────────
if [[ -f /usr/share/bash-completion/bash_completion && -z ${BASH_COMPLETION_VERSINFO:-} ]]; then
  source /usr/share/bash-completion/bash_completion
fi

# ─────────────────────────────
# Complétions spécifiques
# Et outils interactifs
# ─────────────────────────────
eval "$(direnv hook bash)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zellij setup --generate-completion bash)"
eval "$(zoxide init bash)"

# navi
if [ -x "$(command -v navi)" ]; then
  eval "$(navi widget bash)"
  export NAVI_PATH="$HOME/dev/src/github.com/humboldtux/cheats-priv:$HOME/dev/src/github.com/humboldtux/cheats:$HOME/.local/share/navi/cheats"
fi

# ─────────────────────────────
# Aliases & fonctions utilisateur
# ─────────────────────────────
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"
[ -f "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"

# ─────────────────────────────
# Extensions locales (optionnel)
# ─────────────────────────────
if [ -d "$HOME/.bashrc.d" ]; then
  shopt -s nullglob
  for file in "$HOME"/.bashrc.d/*.sh; do
    [ -r "$file" ] && source "$file"
  done
  shopt -u nullglob
fi

# ─────────────────────────────
# Fonctions perso
# ─────────────────────────────
fzf_zoxide_cd() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --reverse) && cd "$dir"
}

bind -x '"\C-f": fzf_zoxide_cd'
