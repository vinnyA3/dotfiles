# Get the current dir - now we can run this script from anywhere

export DOTFILES_DIR

DOTFILES_DIR=cd "$(dirname "${BASH_SOURCE[0]}")" && pwd

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first

if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Create symlinks

ln -sfv $DOTFILES_DIR/runcom/.bash_profile ~
ln -sfv $DOTFILES_DIR/git/.gitconfig ~
ln -sfv $DOTFILES_DIR/config ~/.config
# ln -sfv $DOTFILES_DIR/colors ~/.colors
ln -sfv $DOTFILES_DIR/vim ~/.vim
ln -sfv $DOTFILES_DIR/nvm ~/.nvm
ln -sfv $DOTFILES_DIR/tmux/.tmux.conf ~/.tmux.conf
ln -sfv $DOTFILES_DIR/xmonad ~/.xmonad
ln -sfv $DOTFILES_DIR/x-files/.xinitrc ~/.xinitrc
ln -sfv $DOTFILES_DIR/x-files/.xserverrc ~/.xserverrc
ln -sfv $DOTFILES_DIR/xfiles/.Xresources ~/.Xresources
