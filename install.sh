#!/bin/bash

# ==== FUNCTIONS =====
function detect_linux_distro {
  local DISTRO=$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 | sed -E 's/[\"]+//g') 

  case $DISTRO in
    'Void Linux') PKG_INSTALL_CMD="sudo xbps-install -Syu";;
    'Pop!_OS 20.04 LTS') PKG_INSTALL_CMD="sudo apt-get install";;
    *) echo "Your distro wasn't found.  Please add to the script (fn detect_linux_distro), or install git & stow manually."; exit
    ;;
  esac
}

# install_pkgs :: *(String - OS) -> (String - distro's installed) -> VOID
function install_pkgs {
  case "$1" in
    'MAC'*) 
      if [ -x $(which brew | head -n1) 2>/dev/null ]
      then
        # Brew exists on machine, install git & stow with Homebrew
        brew install git
        brew install stow
      else
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

        # : === noop
        [ -x $(which brew | head -n1) 2>/dev/null ] && : || 
          echo "Something went wrong while installing Homebrew!
                Please check above logs or, install homebrew manually."; exit
      fi
      ;;
    'LINUX'*)
      detect_linux_distro # call fn
      if [ -z "$PKG_INSTALL_CMD" ]
      then
        echo "Your installer was not detected!"; exit
      else
        $PKG_INSTALL_CMD git
        $PKG_INSTALL_CMD stow
      fi
      ;;
    *) echo 'Sorry, your platform is not supported :('; exit;;
  esac
}

function setup_symlinks {
  local SYS=$(uname -s) # get OS info .. again

  if [ -x $(which stow | head -n1) 2>/dev/null ]
  then
    echo "Creating symlinks..."
    stow runcom
    stow git
    stow zsh
    stow vim
    stow tmux

    if [ -d "$HOME/.config" ]
    then
      printf "Looks like you already have a .config directory located in $HOME.\n
If you need configs from '.dotfiles/config', please add them manually."
    else
      stow config
    fi

    if [ $SYS == 'Linux' ]
    then
      stow xmonad
      stow x-files
    fi
  else
    printf "GNU's stow is not available! Something must have went wrong during\n
installation. Please refer to the error logs above, or install stow\n
manually."
  fi
}

# =====  Initial setup =====
# First, we install all the necessary tools to get up & running 
# These tools include: git, homebrew(if on MACOS), GNU stow

# detect if we already have necessary tooling installed
# if so, then just stow * git right away, else, install

echo "Let's get started!
First, we need to install the following tools:

git - essential version control
homebrew - pkg manager for MACOSX (this won't get installed if you're running on
Linux)
stow - GNU's defacto sym link manager

Is this okay? (Y/N)
"

read USER_CONFIRMATION

if [ $(echo $USER_CONFIRMATION | tr '[:upper:]' '[:lower:]') == 'y' ]
then
  SYS=$(uname -s) # get OS info
  case "${SYS}" in
    "Linux"*)  install_pkgs "LINUX";; #detect pkg manager;
    "Darwin"*) install_pkgs "MAC";; # install pkgs 
    CYGWIN*) echo "Sorry, Windows isn't supported at the moment :)"; exit;;
  esac

  # Get the current dir - now we can run this script from anywhere
  export DOTFILES_DIR

  DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

  # Make utilities available
  PATH="$DOTFILES_DIR/bin:$PATH"

  # Update dotfiles itself first
  if [ -x git -a -d "$DOTFILES_DIR/.git" ]; then
      git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
      # update and pull submodules (if we have)
      git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" submodule init
  fi

  # run stow
  setup_symlinks

  echo -e "\n\nSetup is finished!!  You're good to go :)"; exit
else
  echo -e "\nNo worries.  Come back when you're ready."
  exit 1
fi

