:memo: Vim/Neovim
======

Here lies the main editor configuration! 

The file hierarchy is as follows:

```
vim/.vim
├── README.md - documentation
├── general.vimrc - general vim settings
├── init.vimrc - the main entry point (this is what sources the rest of the
config)
├── keys.vimrc - custom keybindings & settings
└── plugins.vimrc - plugin specific configuration
└── lua
    └── config - neovim-specific plugin config, written in Lua
```

See [Files](#files) for a bit more information.

**Note 1**: If you ran the installer script and the script failed, or you opted
to add things manually;
and you're choosing to use `nvim` > `vim`; and you want to use this configuration/setup, then you're going to need to add an `init.vim` to your `~/.config/nvim`
directory with the following contents:

```
set runtimepath^=~/.vim runtimepath+=~/.vim/after
source $HOME/.vim/init.vimrc
source $HOME/.vim/general.vimrc
source plugin setup and keybindings
source $HOME/.vim/plugins.vimrc
source $HOME/.vim/keys.vimrc
```

**Note 2**: I use the nightly (development/unstable) version of [Neovim](https://neovim.io/).  Most things should work for Vim as well; however, I
can't make any promises.


**Note 3**: The nightly version is necessary (as of now) for NVIM-LSP
functionality.

----

### Getting Started

To run and manage plugins, you're going to need [minpac](https://github.com/k-takata/minpac).  `minpac` is a convenience wrapper for Vim 8's plugin system.

##### Linux & macOS

Vim & Neovim (this will only work for neovim if you set the *rtp* in `.config/nvim/init.vim`):

```sh
git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
```

Once you have `minpac` installed, you're pretty much good to go.  You're just
going to need to install the plugins listed in `init.vimrc` with: `:PackUpdate`.

This is pretty much all you need to know to work with minpac:
* `:PackUpdate` - run this to install and/or update plugins
* `:PackClean` - cleans plugin dir when you remove a plugin from the list
* `:PackStatus` - check plugins status

---

### Files

#### `init.vimrc`:

This file is the main entry point.  While all `.vimrc` files get sourced by vim
on startup, `init` will always run first.  In this file, you're find the plugin
list (managed by `minpac`) and `minpac`'s initial configuration.

If `minpac` does not exist, the pluginless environment will run.

Additionally, you'll find some conditions in this file.  Basically, if
you're running Neovim, `deoplete` (nvim autocompletion), `neosnippets` and
`nvim-lsp` will be added to the runtime path.

Quick notes about `nvim-lsp`:

  * If you're using `nvim-lsp`, consult the following: https://github.com/neovim/nvim-lspconfig
  * Check the [config/nvim](https://github.com/vinnyA3/dotfiles/tree/master/config/.config/nvim) directory for LSP lua config!

#### `plugins.vimrc`:

Here, you'll find plugin-specific configuration.  Each config 'block'/section
begins with a comment `"Plugin <plugin name>`--this helps with file navigation.

#### `general.vimrc`:

This file contains basic, universal settings (ie. leader key setup, tab settings, cursor,
modelines, textwidth...).  Additionally, the `colorscheme` and filetype detection
settings live here.

#### `keys.vimrc`:

The keys file contains custom keybindings & keybinding overrides.

#### `lua/config`:

:warning: This is breaking config!  The configuration here will only work for
Neovim Nightly (development version of neovim)! **USE AT YOUR OWN RISK!**

You'll find configuration for lua-based plugins here.  You *could* put this
stuff in a vim file, but I find it better to separate things.

----

### Additional Notes & Tips

* `markdown-preview.nvim` requires NodeJS.  Additionally, if you're using the
  LSP for JavaScript dev, you're going to need Node.
* For icons, I tried using UTF-8 emojis for universal support.  On Mac, I can say that some of the icons are offset vertically ... if they're a bother, feel free to change them up!
* Some additional binaries you're going to need to install for the corresponding
  wrappers/plugins:

    * `fzf` - fuzzy file search
    * `nnn` - terminal file manager
    * `ripgrep` - line oriented search tool that recursively searchs your
      current directory for a regex pattern 
    
:warning: If you're using the LSP w/ typescript support, you need to install the
appropriate packages manually.  You can no longer install necessary binaries via
`:LspInstall` (deprecated).
