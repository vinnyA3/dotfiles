# =============
#    EXPORT
# =============
export EDITOR="vim"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config
export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export PATH=$HOME/.local/bin:/usr/local/opt/gnu-getopt/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --follow -f -g ""'
# androidz
export ANDROID_HOME=~/Library/Android/sdk
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

# fff
export FFF_HIDDEN=0
export FFF_OPENER="xdg-open"
export FFF_FAV1=~/Development
export FFF_FAV2=~/Pictures/wallpaper
export FFF_FAV3=~/Documents/
export FFF_FAV4=~/Documents/ebooks

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# man pages - requires bat (https://github.com/sharkdp/bat) binary
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
