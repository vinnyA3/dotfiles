#!/bin/bash

# Install.sh
# ==========
#
# [IMPORTANT NOTE] Make sure both Git & GNU's Stow are installed before running
# the script; they are necessary dependencies
#
#
# Description: This script uses [stow] to create the appropriate symlinks
# If you decide there were some things that you don't want/need that were
# linked, you can delete it from your HOME directory ..
#   TIP: view symlinks with `ls -la` in your HOME directory, then proceed to
#   remove the link: `rm <link>`

DOTFILES_DIR=$HOME/.dotfiles
STOW_FOLDERS="bin,config,git,tmux,zsh"

# ==== FUNCTIONS =====
function setup_symlinks {
  if command -v stow 2>&1 > /dev/null;
  then
    echo "Creating symlinks..."

    # https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash
    # warning, this is read to a 'global' folders array .. therefore this function
    # is NOT pure .. keep that in mind.  This should pose an issue, but it's worth noting.
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
  else
    echo "GNU's stow is not available! Something must have went wrong during
    installation. Please refer to the error logs above, or install stow
    manually."
    exit 1
  fi
}

# =====  Initial setup =====
# First, we install all the necessary tools to get up & running 
# These tools include: git, homebrew(if on MACOS), GNU stow

# detect if we already have necessary tooling installed
# if so, then just stow * git right away, else, install

NORMALIZED_STOW_FOLDERS=$(echo "$STOW_FOLDERS" | sed -e 's/,/, /g')

echo "Let's get started!
The following directories will be symlinked to $HOME:

  ${NORMALIZED_STOW_FOLDERS}

Is this okay? (Y/N)
"

read USER_CONFIRMATION

if [ $(echo $USER_CONFIRMATION | tr '[:upper:]' '[:lower:]') == 'y' ]
then
  # cd / push dotfiles directory to top of dir stack
  pushd $DOTFILES_DIR 2>&1 > /dev/null

  # run stow
  setup_symlinks

  echo -e "\n\nSetup is finished!!  You're good to go :)"
  exit 0
else
  echo -e "\nNo worries.  Come back when you're ready.  You can always run 'stow <directory>' to control what gets linked."
  exit 0
fi

