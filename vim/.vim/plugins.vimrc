" plugins defined in .vim/init.vim using minpac
" this contains plugin specific setup and keybindings

" Plugin: fzf
" set rtp+=/usr/bin/fzf " fzf must exist 
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf " using brew to install latest ver. for now
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
nnoremap <C-p> :FZF<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <Leader>h :History<Cr>
nnoremap <Leader>r :Rg<Cr>

" Plugin: fff 
nnoremap <Leader>f :F<CR>
let g:fff#split = "30new"

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
let g:startify_custom_header = [
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\]

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
      \ 'colorscheme': 'palenight',
      \ 'component': {
      \   'lineinfo': '📄 %3l:%-2v',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype'] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'parentDirAndFilename' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightLineGitBranch',
      \   'parentDirAndFilename': 'LightLineFilename'
      \ }
    \ }
" requires vim fugitive wrapper
function! LightLineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
" get branch name from vim-fugitive
function! LightLineGitBranch()
  let l:branch = fugitive#head()
  return l:branch ==# '' ? '' : '🔨 ' . l:branch
endfunction

" Plugin: markdown-preview.nvim
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

" Plugin: vim-jsx-pretty
let g:vim_jsx_pretty_template_tags = ['html', 'js', 'jsx']
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:vim_jsx_pretty_colorful_config = 1


" Plugin: diagnostic-nvim 
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = '<'
let g:diagnostic_insert_delay = 1
call sign_define("LspDiagnosticsErrorSign", {"text" : "✘", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text": "⚠️ "}) 
call sign_define("LspDiagnosticsInformationSign", {"text": "💬"}) 
call sign_define("LspDiagnosticsHintSign", {"text": "▶️ "})

" Plugin: completion-nvim 
let g:completion_enable_snippet = 'Neosnippet'
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet', 'buffers']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]
autocmd BufEnter * lua require'completion'.on_attach()

" Plugin: palenight.vim
let g:palenight_terminal_italics=1
