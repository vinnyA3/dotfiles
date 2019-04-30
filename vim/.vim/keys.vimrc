nmap <silent> <leader>t :exec &rnu? "se rnu!" : "se rnu"<CR>
" copy selected text to system clipboard (requires vim compiled with x-11)
vnoremap <C-c> "*y :let @+=@*<CR>
map <C-v> "+P
 " - easy buffer navigation
noremap <leader>n :bn<cr>
noremap <leader>p :bp<cr>
noremap <leader>d :bd<cr>
" read escape in terminal .. double tap to go back to insert mode
tnoremap <Esc><Esc> <C-\><C-n>
" easy window navigation - when in term
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
" disable arrow keys
nnoremap <up> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <down> <nop>
" rebind arrow keys to window resize
map <left> :5winc ><CR>
map <right> :5winc <<CR>
map <down> :5winc +<CR>
map <up> :5winc -<CR>
" search and replace all occurences of focused word
nmap <Leader>s :%s/\<<C-r><C-w>\>/
