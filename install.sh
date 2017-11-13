# Get the current dir - now we can run this script from anywhere

DOTFILES_DIR=cd "$(dirname "${BASH_SOURCE[0]}")" && pwd

# Create symlinks

ln -sfv $DOTFILES_DIR/runcom/.bash_profile ~
ln -sfv $DOTFILES_DIR/runcom/.git/.gitconfig ~
ln -sfv $DOTFILES_DIR/runcom/vim ~/.vim

