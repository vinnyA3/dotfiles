local set_keymap = vim.api.nvim_set_keymap

-- setup leader key first and foremost
set_keymap('n', '<Space>', '', {})
set_keymap('v', '<Space>', '', {})

vim.g.mapleader = " "

require('core/options')
require('core/keybindings')
require('plugins/init')
require('plugins/config')
require('lsp/init')
