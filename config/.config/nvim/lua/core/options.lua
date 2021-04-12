local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd

-- global
o.hidden = true
o.termguicolors = true
o.splitbelow = true
o.splitright = true
o.textwidth = 80
o.hls = false
o.showmatch = false
o.showmode = false
o.joinspaces = false
o.backup = false
o.writebackup = false
o.swapfile = false
o.completeopt= 'menuone,noinsert,noselect'
o.showbreak = "↳  "
o.expandtab = true
o.indentexpr = 'off'
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2

-- buffer options
bo.modeline = false
bo.fileencoding = 'utf-8'
bo.syntax = 'on' 
bo.autoindent = true

-- window options
wo.number = true

-- command options
cmd('set shortmess+=c') -- avoid showing extra message when using completion
cmd('set path+=**') 
