# Source aliases
source $HOME/.zsh_aliases
source $HOME/.zshenv

# Set vim terminal keybindings
bindkey -v
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# ==============
#    NVM Node
# ==============
#Add every binary that requires nvm, npm or node to run to an array of node globals
NODE_GLOBALS=(`find ~/.dotfiles/nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

# Lazy-loading nvm + npm on node globals call
load_nvm () {
  export NVM_DIR=~/.dotfiles/nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

# Making node global trigger the lazy loading
for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done

npm-do () {
  PATH=$(npm bin):$PATH
  eval $@
}

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
#      NNN 
# ==============
n() {
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
      echo "nnn is already running"
      return
  fi

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "export" as in:
  #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  # NOTE: NNN_TMPFILE is fixed, should not be modified
  NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef

  nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
  fi
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
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==============
#    PROMPT
# ==============

eval "$(starship init zsh)" # requires https://github.com/starship/starship
# eval "$(rbenv init -)"
