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

" Try to load minpac
let &packpath = &runtimepath
packadd minpac

if exists('g:loaded_minpac')
  " minpac is loaded
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " additional plugins
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('ap/vim-css-color', {'type': 'opt'})
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('drewtempelmeyer/palenight.vim', { 'name': 'palenight' })
  call minpac#add('dracula/vim', { 'name': 'dracula' })
  call minpac#add('dylanaraps/fff.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('junegunn/vim-peekaboo')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! call mkdp#util#install()'})
  call minpac#add('mattn/emmet-vim')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('neovim/nvim-lspconfig') 
  call minpac#add('nvim-lua/completion-nvim')
  call minpac#add('nvim-treesitter/nvim-treesitter', { 'type': 'opt' })
  call minpac#add('prettier/vim-prettier')
  call minpac#add('Shougo/neosnippet.vim')
  call minpac#add('Shougo/neosnippet-snippets')
  call minpac#add('steelsojka/completion-buffers')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('udalov/kotlin-vim')
  call minpac#add('Yggdroot/indentLine')

  packadd! palenight  "colors error out if it's not added to RTP

  if has('nvim')
    packadd nvim-lspconfig
    packadd nvim-treesitter
    " TODO: move to designated lua file
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"typescript", "javascript"},
  incremental_selection = {
      enable = false,
  },
  highlight = {
    enable = true,
  },
}
EOF
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
