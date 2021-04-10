if executable('nvim')
  set hidden " avoid term buffers from closing on buf switch
  set termguicolors
  " https://github.com/mhinz/neovim-remote/blob/master/INSTALLATION.md
  " * check installation path (.local/bin, /usr/local/bin)
  if executable('nvr') " check for nvr to avoid nesting sessions
    autocmd FileType gitcommit set bufhidden=delete
    let $VISUAL="nvr -cc split --remote-wait"
  endif
endif

" Try to load minpac by adding to the RTP
let &packpath = &runtimepath
packadd minpac

if exists('g:loaded_minpac')
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " additional plugins
  call minpac#add('bluz71/vim-moonfly-colors')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('dylanaraps/fff.vim')
  call minpac#add('glepnir/dashboard-nvim')
  call minpac#add('glepnir/indent-guides.nvim')
  call minpac#add('glepnir/lspsaga.nvim')
  call minpac#add('hoob3rt/lualine.nvim')
  call minpac#add('hrsh7th/nvim-compe')
  call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! call mkdp#util#install()'})
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('junegunn/vim-peekaboo')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('lewis6991/gitsigns.nvim')
  call minpac#add('mattn/emmet-vim')
  call minpac#add('neovim/nvim-lspconfig') 
  call minpac#add('norcalli/nvim-colorizer.lua') " config in lua/config
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})
  call minpac#add('prettier/vim-prettier')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')

  if has('nvim')
    packadd nvim-lspconfig
    packadd nvim-treesitter
    lua require('config')
  endif

  if executable('node')
    packadd markdown-preview.nvim
  endif

  " minpac commands
  " note: $MYVIMRC is sourced in .config/nvim/init.vimrc .. I think .. I actually have no fucking clue
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
endif
