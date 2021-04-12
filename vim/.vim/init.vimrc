" TODO: move the following two config settings to general 
set hidden " avoid term buffers from closing on buf switch
set termguicolors " take advantage of term's full color capabilities

" https://github.com/mhinz/neovim-remote/blob/master/INSTALLATION.md
" * check installation path (.local/bin, /usr/local/bin)
if executable('nvr') " check for nvr to avoid nesting sessions
  autocmd FileType gitcommit set bufhidden=delete
  let $VISUAL="nvr -cc split --remote-wait"
endif

lua require('plugins-init')
lua require('config')
