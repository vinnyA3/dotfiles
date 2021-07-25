#!/bin/bash

# Install.sh
# ==========
# First, we'll try to detect your OS...
# If you're on a Mac, homebrew will be installed (if you already have Homebrew +
#   stow or git, don't worry .. things won't get installed again)

# If you're on Linux, we'll detect your distro & attempt to use your distro's
#   default package manager to install the stow & git

# Finally, we'll use stow to create the appropriate symlinks
# If you decide there were some things that you don't want/need that were
# linked, you can delete it from your HOME directory ..
#   TIP: view symlinks with `ls -la` in your HOME directory, then proceed to
#   remove the link: `rm <link>`

DOTFILES_DIR=$HOME/.dotfiles
STOW_FOLDERS="bin,config,git,tmux,zsh"

# ==== FUNCTIONS =====
function detect_linux_distro {
  local DISTRO=$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 | tr -d '"') 

  case $DISTRO in
    'Void Linux') PKG_INSTALL_CMD="sudo xbps-install -Syu";;
    'Pop!_OS 20.04 LTS') PKG_INSTALL_CMD="sudo apt-get install";;
    'Pop!_OS 21.04') PKG_INSTALL_CMD="sudo apt-get install";;
    *)
      echo "Your distro wasn't found.  Please add to the script (fn detect_linux_distro), or install git & stow manually."
      exit 0
    ;;
  esac
}

# install_pkgs :: *(String - OS) -> (String - distro's installed) -> VOID
function install_pkgs {
  case "$1" in
    'MAC'*) 
      if [ ! -x $(which brew | head -n1) 2>/dev/null ]
      then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # Check if the installation was successful 
        [ -x $(which brew | head -n1) 2>/dev/null ] && : || 
          echo "Something went wrong while installing Homebrew!
                Please check above logs or, install homebrew manually."
          exit 1
      fi
      # Brew exists on machine, try to install git & stow with Homebrew
      if ! command -v git 2>&1 > /dev/null;
      then
        brew install git
      fi

      if ! command -v stow 2>&1 > /dev/null;
      then
        brew install stow
      fi
      ;;
    'LINUX'*)
      detect_linux_distro # call fn
      if [ -z "$PKG_INSTALL_CMD" ]
      then
        echo "Your pkg installer was not detected!"; exit
      else
        if ! command -v git 2>&1 > /dev/null;
        then
          $PKG_INSTALL_CMD git
        fi

        if ! command -v stow 2>&1 > /dev/null;
        then
          $PKG_INSTALL_CMD stow
        fi
      fi
      ;;
    *)
      echo 'Sorry, your platform is not supported :('
      exit 0
      ;;
  esac
}

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

echo "Let's get started!
First, we need to install the following tools:

git - essential version control
stow - GNU's defacto sym link manager
homebrew - pkg manager for macOS (this won't get installed if you're running on
Linux)

note: if you already have these tools, we won't install them again.

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

  # Make utilities available
  # PATH="$DOTFILES_DIR/bin:$PATH"
  # Update dotfiles itself first
  # if [ -x git -a -d "$DOTFILES_DIR/.git" ]; then
  #     git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
  #     # update and pull submodules (if we have)
  #     git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" submodule init
  # fi

  # cd / push dotfiles directory to top of dir stack
  pushd $DOTFILES_DIR 2>&1 > /dev/null

  # run stow
  setup_symlinks

  echo -e "\n\nSetup is finished!!  You're good to go :)"
  exit 0
else
  echo -e "\nNo worries.  Come back when you're ready."
  exit 0 
fi

