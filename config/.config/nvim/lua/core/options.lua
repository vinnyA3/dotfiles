local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd
local indentSize = 2

-- global
o.hidden = true
o.termguicolors = true
o.splitbelow = true
o.splitright = true
o.textwidth=80
o.hls = false
o.showmatch = false
o.showmode = false
o.joinspaces = false
o.backup = false
o.completeopt= 'menuone,noinsert,noselect'

-- buffer options
o.fileencoding = 'utf-8'
bo.syntax = 'on' 
bo.autoindent = true
bo.expandtab = true
bo.indentexpr = 'off'
bo.tabstop = indentSize
bo.softtabstop = indentSize
bo.shiftwidth = indentSize
bo.swapfile = false

-- window options
wo.number = true

-- command options
cmd('set shortmess+=c') -- avoid showing extra message when using completion
cmd('set path+=**') 
