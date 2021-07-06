# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # source .bashrc if it exists
    if [ -f "$HOME/.bashrc" ];
    then
	    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
   # added by Nix installer - $HOME env var was manually added
  . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

# swapesc is a custom script which swaps 'esc' key with 'capslock' key
# -- see [ ~/.local/bin ] 
# -- note: this is really only needed on linux box w/o easy key swap config
if command -v swapesc > /dev/null; then
  swapesc
fi
