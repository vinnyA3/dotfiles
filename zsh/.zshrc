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
#    NVM Node
# ==============
#Add every binary that requires nvm, npm or node to run to an array of node globals
NODE_GLOBALS=(`find $XDG_CONFIG_HOME/nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

# Lazy-loading nvm + npm on node globals call
load_nvm () {
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
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
# linux sourced
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==============
#    PROMPT
# ==============

eval "$(starship init zsh)" # requires https://github.com/starship/starship
# eval "$(rbenv init -)" # pretty sure I only use this on Mac
