function! CheckNvim()
  if has('nvim')
    set hidden " avoid term buffers from closing on buf switch
    set termguicolors
    if executable('nvr') " check for nvr to avoid nesting sessions
      autocmd FileType gitcommit set bufhidden=delete
      let $VISUAL="nvr -cc split --remote-wait"
    endif
  endif
endfunction

" Try to load minpac
let &packpath = &runtimepath
packadd minpac

if !exists('*minpac#init') "load plugin-less env
  call CheckNvim()
else
  call CheckNvim()
  " minpac is loaded
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " additional plugins
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('ap/vim-css-color', {'type': 'opt'})
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('dylanaraps/fff.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('junegunn/vim-peekaboo')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('lifepillar/vim-mucomplete', {'type': 'opt'})
  call minpac#add('mike-hearn/base16-vim-lightline')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('neoclide/coc.nvim', {'type': 'opt'}) 
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')
  
  if executable('node')
    packadd coc.nvim
  else
    packadd vim-css-color
    packadd vim-mucomplete 
  endif
  " minpac Commands
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
endif
