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

if exists('*minpac#init')
  " minpac is loaded
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " additional plugins
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('ap/vim-css-color', {'type': 'opt'})
  " call minpac#add('aurieh/discord.nvim') " this plugin updates too quickly, might fork || make own ¯ \_(ツ)_/¯
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('dracula/vim', { 'name': 'dracula' })
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('junegunn/vim-peekaboo')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! call mkdp#util#install()'})
  call minpac#add('lifepillar/vim-mucomplete', {'type': 'opt'})
  call minpac#add('maxmellon/vim-jsx-pretty')
  call minpac#add('mcchrish/nnn.vim')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('neovim/nvim-lspconfig') 
  call minpac#add('Shougo/deoplete.nvim') " vim8 compatilble as well
  call minpac#add('Shougo/deoplete-lsp')
  call minpac#add('Shougo/neosnippet.vim')
  call minpac#add('Shougo/neosnippet-snippets')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('Yggdroot/indentLine')
  call minpac#add('yuezk/vim-js')

  packadd! dracula " add dracula to RTP - errors out if it's not

  if executable('nvim')
    packadd nvim-lspconfig " lsp-config
    packadd deoplete.nvim
    packadd deoplete-lsp

    if executable('node')
      packadd markdown-preview.nvim
    else
      packadd vim-mucomplete " simple autocompletion
    endif
  endif

  " minpac commands
  " note: $MYVIMRC is sourced in .config/nvim/init.vimrc .. I think .. I actually have no fucking clue
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
endif
