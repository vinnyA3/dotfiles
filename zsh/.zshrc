# Source aliases
source $HOME/.zsh_aliases
# this is commented for now, looks like zsh will source this automatically? or maybe
# is sourced somewhere else ... who knows ... whatever
# source $HOME/.zshenv

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
#      NNN
# ==============
nnn () {
    # Reference: https://github.com/jarun/nnn/wiki/Basic-use-cases#configure-cd-on-quit
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
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
