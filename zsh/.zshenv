# =============
#    EXPORT
# =============
export EDITOR="vim"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx # probably not even needed tbh
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME

export PATH=$HOME/.local/bin:/usr/local/bin:/usr/local/opt/gnu-getopt/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --follow -f -g ""'

# colored, pretty man pages - requires bat (https://github.com/sharkdp/bat) binary
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# androidz
export ANDROID_HOME=$HOME/Library/Android/sdk
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# fff
export FFF_FAV1=~/.dotfiles
export FFF_FAV2=~/Development/equinox-work/app-mobile
export FFF_FAV3=~/Documents/notes/
