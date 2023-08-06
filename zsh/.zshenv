# =============
#    EXPORT
# =============

# editor(script) - please check script exists in '.local/bin'
export EDITOR=$HOME/.local/bin/editor # aliases to nvim

# zk (cli tool for second brain note archive) - https://github.com/mickael-menu/zk
export ZK_NOTEBOOK_DIR=$HOME/Documents/brain-stew

export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx # probably not even needed anymore tbh
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME

export PATH=$PATH:$HOME/.local/bin:/usr/local/bin:/usr/local/opt/gnu-getopt/bin:$HOME/.cargo/bin:/usr/local/opt/llvm/bin

# requires fzf installed
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# tmuxp - https://github.com/tmux-python/tmuxp
export TMUXP_CONFIGDIR=$HOME/.dotfiles/tmux/.tmux/sessions

# colored, pretty man pages - requires bat (https://github.com/sharkdp/bat) binary
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# androidz (linux - popos default install)
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export JAVA_HOME=$(/usr/libexec/java_home)

# volta - nodejs version manager
export VOLTA_HOME=$HOME/.volta
export PATH=$PATH:$VOLTA_HOME/bin # add volta to path

# fff - configuration
export FFF_FAV1=~/.dotfiles
export FFF_FAV2=~/Development/equinox-work/app-mobile
export FFF_FAV3=~/Documents/notes/

# lynx
export LYNX_CFG=$XDG_CONFIG_HOME/lynx.cfg
export LYNX_LSS=$XDG_CONFIG_HOME/lynx.lss

# local secrets (used for various custom scripts)
if [ -f $HOME/.env_secrets ]; then
  source $HOME/.env_secrets
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ];
  then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
    . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh;
fi # added by Nix installer
