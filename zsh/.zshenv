# =============
#    EXPORT
# =============
export EDITOR=$HOME/.local/bin/nvim # aliases to nvim
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx # probably not even needed anymore tbh
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME

export PATH=$HOME/.local/bin:/usr/local/bin:/usr/local/opt/gnu-getopt/bin:$HOME/.cargo/bin:$PATH:/usr/local/opt/llvm/bin:$PATH

# requires fzf installed
export FZF_DEFAULT_COMMAND='ag --hidden --follow -f -g ""'

# colored, pretty man pages - requires bat (https://github.com/sharkdp/bat) binary
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# androidz (linux - popos default install)
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export JAVA_HOME=$(/usr/libexec/java_home)

# fff - configuration
export FFF_FAV1=~/.dotfiles
export FFF_FAV2=~/Development/equinox-work/app-mobile
export FFF_FAV3=~/Documents/notes/

# lynx
export LYNX_CFG=$XDG_CONFIG_HOME/lynx.cfg
export LYNX_LSS=$XDG_CONFIG_HOME/lynx.lss
