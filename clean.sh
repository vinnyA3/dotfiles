#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles

STOW_FOLDERS="bin,config,git,tmux,zsh"

if ! command -v stow > /dev/null
then
  echo "You need 'stow', the symlink manager, installed!"
  exit 1
fi

pushd $DOTFILES_DIR 2>&1 > /dev/null

# creates array, folders, from string
readarray -td, folders <<< "$(echo $STOW_FOLDERS),"
unset 'folders[-1]'
declare -p folders 2>&1 > /dev/null

for folder in "${folders[@]}"
do
  echo "Removing $folder"
  stow -D $folder # clean env
done

echo "Your environment is now clean!"
popd 2>&1 > /dev/null
exit 1
