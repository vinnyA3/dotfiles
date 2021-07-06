# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
READLINK=$(which readlink || which greadlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available
# PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters here)
for DOTFILE in "$DOTFILES_DIR"/sys/.{profile,functions,env,nvm,alias,completion,prompt,terminal}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# export
export DOTFILES_DIR
