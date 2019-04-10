# =============
#    EXPORT
# =============
export EDITOR="vim"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --follow --ignore .git -f -g ""'

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
