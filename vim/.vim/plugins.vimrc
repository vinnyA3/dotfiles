" plugins defined in .vim/init.vim using minpac
" this contains plugin specific setup and keybindings

" Plugin: COC
if executable('node')
  set shortmess+=c

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " use <c-space> for trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()
  " use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
  " coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " use `[c` and `]c` for navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)
  " remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " formatter
  command! -nargs=0 Prettier :CocCommand prettier.formatFile

" load some helpful plugins that coc.nvim would have taken care of for us
else   
"   " Plugin: MuComplete
  set completeopt+=menuone
  set completeopt+=noselect
  set shortmess+=c
  let g:mucomplete#enable_auto_at_startup = 1
endif

" Plugin: fzf
set rtp+=/usr/bin/fzf " fzf must exist 
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
nnoremap <C-p> :FZF<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <Leader>h :History<Cr>
nnoremap <Leader>r :Rg<Cr>

" Plugin: nnn 
" disable default mappings
let g:nnn#set_default_mappings = 0
let g:nnn#layout = 'new'
nnoremap <Leader>f :NnnPicker<CR>

" Plugin: netrw {{{2
let g:loaded_netrwPlugin = 1
let g:dirvish_relative_paths = 0
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

" Plugin: GitGutter
set updatetime=1000
nmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gb <Plug>(GitGutterPrevHunk)

" Plugin: vim-jsx
let g:jsx_ext_required = 0

"Plugin: Fugitive
nnoremap <Leader>gc :Gcommit<Cr>

" Plugin: Startify
let g:startify_custom_header =
        \ map(split(system('figlet MLS'), '\n'), '"   ". v:val')

let g:startify_files_number = 10

let g:startify_session_dir = '~/.vim/session'

let g:startify_lists = [
      \ { 'type': 'files',     'header': [   'Recent Files']   },
      \ { 'type': 'bookmarks', 'header': [   'Bookmarks']      },
      \ { 'type': 'sessions',  'header': [   'Sessions']       },
      \ { 'type': 'commands',  'header': [   'Commands']       },
      \ ]

" Plugin: indentLine
let g:indentLine_fileTypeExclude = ['json', 'md']

" Plugin: Lightline
" currently using lightline: https://github.com/itchyny/lightline.vim
" colorscheme for lightline: https://github.com/mike-hearn/base16-vim-lightline
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'component': {
      \   'lineinfo': ' %3l:%-2v',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightLineGitBranch'
      \ }
    \ }
" get branch name from vim-fugitive
function! LightLineGitBranch()
  let l:branch = fugitive#head()
  return l:branch ==# '' ? '' : ' ' . l:branch
endfunction

" Plugin markdown-preview.nvim
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_browser = 'chrome'
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }

let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_echo_preview_url = 1 
let g:mkdp_port = '8881'
let g:mkdp_page_title = '「${name}」'

" Plugin vim-jsx-pretty
let g:vim_jsx_pretty_template_tags = ['html', 'js', 'jsx']
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:vim_jsx_pretty_colorful_config = 1
