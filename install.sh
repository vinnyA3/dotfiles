#!/bin/bash
# Get the current dir - now we can run this script from anywhere
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first
if [is-executable git -a -d "$DOTFILES_DIR/.git"]; then
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
    # update and pull submodules
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" submodule init
fi

# Create symlinks (nvm) refactor to use stow ... later
ln -sfv $DOTFILES_DIR/nvm ~/.nvm

# Stow
stow runcom
stow git
stow config
stow vim
stow tmux
stow xmonad
stow x-files
