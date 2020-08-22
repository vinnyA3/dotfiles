" general settings
" remap space for leader
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>
let mapleader = " "

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
set nojoinspaces " pesky 2-spaces after the period thing - substack :p
set guicursor=
" set rtp+=/usr/bin/fzf " fzf must exist 

" indent Settings
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

" finding files recursively
set path+=**

" wild search stuff and such
set wildmenu
set wildignore+=**/node_modules/**

colorscheme dracula
" colorscheme --- currently using base16
" function! s:base16_customize() abort
"   call Base16hi("LineNr", g:base16_gui03, g:base16_gui00, g:base16_cterm03, g:base16_cterm00, "", "")
" endfunction

" augroup on_change_colorschema
"   autocmd!
"   autocmd ColorScheme * call s:base16_customize()
" augroup END


" adhere to terminal tranparency if set
hi Normal guibg=NONE ctermbg=NONE

" set filetypes for files with certain extentions ... helps with plugins
au BufNewFile,BufRead *.ejs set filetype=html 

" set cursorline only in active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup file-types
  autocmd!
  " Override some syntaxes so things look better
  autocmd BufNewFile,BufRead *.ts,*.snap*,*.es6,*.tsx setlocal filetype=javascript.jsx
  autocmd BufNewFile,BufRead *stylelintrc,*eslintrc,*babelrc,*jshintrc setlocal syntax=json
  autocmd BufNewFile,BufRead *.css,*.pcss setlocal syntax=scss filetype=scss
  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

function! Bufs()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': Bufs(),
  \ 'sink*': { lines -> execute('bwipeout '.join(map(lines, {_, line -> split(line)[0]}))) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))
