#!/bin/bash
DOTFILES_DIR=$HOME/.dotfiles

STOW_FOLDERS="bin,config,git,tmux,zsh"

if ! command -v stow > /dev/null
then
  echo "You need 'stow', the symlink manager, installed!"
  exit 1
fi

pushd $DOTFILES_DIR 2>&1 > /dev/null

# https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash
readarray -td, folders <<< "$(echo $STOW_FOLDERS),"
unset 'folders[-1]'
declare -p folders 2>&1 > /dev/null

for folder in "${folders[@]}"
do
  stow -D $folder # clean env
  echo "Installing $folder"
  stow $folder 2>&1 > /dev/null
done

echo "Done!"
popd 2>&1 > /dev/null
exit 1
