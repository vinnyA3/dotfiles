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
  call minpac#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})
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

  packadd! dracula  "colors error out if it's not added to RTP

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

lua << END
local fn = vim.fn
-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local fn = vim.fn

nvim_lsp.tsserver.setup{
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = true
      }
    ),
  }
}

fn.sign_define("LspDiagnosticsSignWarning", { text="⚠️ ", texthl="LspDiagnosticsSignWarning" })
fn.sign_define("LspDiagnosticsSignInformation", { text="💬", texthl="LspDiagnosticsSignInformation" })
fn.sign_define("LspDiagnosticsSignHint", { text="▶️ ", texthl="LspDiagnosticsSignHint" })
fn.sign_define("LspDiagnosticsSignError", { text = "✘", texthl = "LspDiagnosticsDefaultError" })

nvim_lsp.diagnosticls.setup{
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = {
          spacing = 4,
          prefix = '~',
        },
        -- Use a function to dynamically turn signs off
        -- and on, using buffer local variables
        signs = function(bufnr, client_id)
          local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
          -- No buffer local variable set, so just enable by default
          if not ok then
            return true
          end

          return result
        end,
        -- Disable a feature
        update_in_insert = false,
      }
    ),
  };
  filetypes = { "javascript", "javascript.jsx", "typescript", "typescriptreact" };
  init_options = {
    filetypes = {
      javascript = "eslint",
      typescript = "eslint",
      ["javascript.jsx"] = "eslint",
      javascriptreact = "eslint",
      typescriptreact = "eslint",
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".eslintrc", ".eslintrc.json", ".eslintrc.cjs", ".eslintrc.js", ".eslintrc.yml", ".eslintrc.yaml", "package.json" },
        debounce = 100,
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${ruleId}]",
          security = "severity",
        };
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      }
    }
  }
}

END
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
