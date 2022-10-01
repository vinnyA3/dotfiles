# Source aliases
source $HOME/.zsh_aliases
source $HOME/.zshenv

# Set vim terminal keybindings
bindkey -v
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# Source edit-command-line 'plug'
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line # binds cmd-editor trigger to space

# ==============
#    DOCKER
# ==============
docker-env() {
  if [ ! -z "$(uname -s | grep -i darwin)" ] # mac only
  then
    local script_dir=$HOME/.local/bin
    [ -s "$script_dir/docker-machine-env" ] && . "$script_dir/docker-machine-env"
  else
    echo "The quieter you become, the more you are able to hear ..."
  fi
}

# ==============
#      FFF
# ==============
ff() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

# ==============
#      FZF 
# ==============

# fh - repeat history :)
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# ==============
#    AUTOCOMP 
# ==============
autoload -U compinit
compinit

# ==============
#    HISTORY 
# ==============
HISTSIZE=1000000

# ==============
#    PLUGINS
# ==============
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# linux sourced (nix)
source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==============
#    PROMPT
# ==============

# eval "$(rbenv init -)" # pretty sure I only use this on Mac
eval "$(starship init zsh)" # requires https://github.com/starship/starship
