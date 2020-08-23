# =============
#    EXPORT
# =============
export EDITOR="vim"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx # probably not even needed tbh
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config
export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH=$HOME/.local/bin:/usr/local/opt/gnu-getopt/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --follow -f -g ""'

# colored, pretty man pages - requires bat (https://github.com/sharkdp/bat) binary
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# androidz
# export ANDROID_HOME=~/Library/Android/sdk
# export JAVA_HOME=$(/usr/libexec/java_home)
# export PATH=${PATH}:${ANDROID_HOME}/tools
# export PATH=${PATH}:${ANDROID_HOME}/platform-tools
