" general settings
" note: the only config here that require dependecies: colorscheme & autogroup ->
"   autocmd -> indentLines.  The rest can be use in any barebones Vim/Neovim environment.

" remap space for leader
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>
let mapleader = " "

" pretty sane defaults. check :help for setting information
syntax on 
set encoding=UTF-8
set noshowmode
set splitbelow
set splitright
set number
set textwidth=80
set nohls
set noshowmatch
set noshowmode
setlocal spell spelllang=en_us
set nospell
set modeline
set nojoinspaces
set guicursor=

" indent settings
set autoindent
set indentexpr=off
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2 

" backup settings
set nowritebackup
set noswapfile
set nobackup

" finding files recursively - helps with autocomplete in command mode 
set path+=**

" wild search stuff and such
set wildmenu
set wildignore+=**/node_modules/**

" set background=dark -- here if you need
colorscheme moonfly " dependent on whatever colorscheme you have installed 

" adhere to terminal tranparency if set -- turn on if you have a terminal
"   background image
hi Normal guibg=NONE ctermbg=NONE

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" ========== AUTOGROUPS ==========

" set cursorline only in active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup file-types
  autocmd!
  " Override some syntaxes so things look better
  " set filetypes for files with certain extentions ... helps with plugins
  autocmd BufNewFile,BufRead *.ejs set filetype=html 
  autocmd BufNewFile,BufRead *.ts,*.snap*,*.es6 setlocal filetype=typescript.jsx
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
  autocmd BufNewFile,BufRead *stylelintrc,*eslintrc,*babelrc,*jshintrc setlocal syntax=json
  autocmd BufNewFile,BufRead *.css,*.pcss setlocal syntax=scss filetype=scss
  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END
