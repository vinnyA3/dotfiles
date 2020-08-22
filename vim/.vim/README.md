:memo: Vim/Neovim
======

Here lies the main editor configuration!  The organization is a bit
unconventional, and the config is a bit opinionated; but, if you want a solid
development environment, you've found one.

The file hierarchy is as follows:

```
vim/.vim
├── README.md - documentation
├── general.vimrc - general vim settings
├── init.vimrc - the main entry point (this is what sources the rest of the
config)
├── keys.vimrc - custom keybindings & settings
└── plugins.vimrc - plugin specific configuration
```

See [Files](#files) for a bit more information.

**Note**: I use [Neovim](https://neovim.io/).  Most things should work for Vim as well; however, I
can't make any promises.

### Getting Started

To run and manage plugins, you're going to need [minpac](https://github.com/k-takata/minpac).  `minpac` is a convenience wrapper for Vim 8's plugin system.


##### Linux & macOS

Vim:

```sh
git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
```

Neovim (use `$XDG_CONFIG_HOME` in place of `~/.config` if set on your system):

```sh
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
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

Additionally, you'll find some conditions in this file.  Basically, if you have
NodeJS & are running Neovim, then [coc.nvim](https://github.com/neoclide/coc.nvim) will be added to the runtimepath;
however, it should be noted that `coc.nvim` gets installed regardless--you can
remove the sourcing line & run a `:PackClean` if you choose to opt out of using
`coc`.

#### `plugins.vimrc`:

Here, you'll find plugin-specific configuration.  Each config 'block'/section
begins with a comment `"Plugin <plugin name>`--this helps with file navigation.

#### `general.vimrc`:

This file contains basic, universal settings (ie. leader key setup, tab settings, cursor,
modelines, textwidth...).  Additionally, the `colorscheme` and filetype detection
settings live here.

#### `keys.vimrc`:

The keys file contains custom keybindings & keybinding overrides.
