local nvim_treesitter = require'nvim-treesitter.configs'
local nvim_lsp = require'lspconfig'
local saga = require'lspsaga'
local fn = vim.fn

nvim_treesitter.setup {
  ensure_installed = {"typescript", "javascript"},
  incremental_selection = {
      enable = false,
  },
  highlight = {
    enable = true,
  },
}

nvim_lsp.tsserver.setup{
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = true
      }
    ),
  };
  filetypes = { "javascript", "javascript.jsx", "typescript", "typescriptreact" };
}

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

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  allow_prefix_unmatch = false;
  source = {
    path = true;
    buffer = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

--lspsaga
saga.init_lsp_saga {
  border_style = 2
}

--colorizer
require 'colorizer'.setup {
  'javascript';
  'typescript';
  'css';
  javascript = { css = true; };
  typescript = { css = true; };
  css = { rgb_fn = true; };
}

--- quick diagnotics
fn.sign_define("LspDiagnosticsSignWarning", { text="⚠️ ", texthl="LspDiagnosticsSignWarning" })
fn.sign_define("LspDiagnosticsSignInformation", { text="💬", texthl="LspDiagnosticsSignInformation" })
fn.sign_define("LspDiagnosticsSignHint", { text="▶️ ", texthl="LspDiagnosticsSignHint" })
fn.sign_define("LspDiagnosticsErrorSign", { text = "✘", texthl = "LspDiagnosticsDefaultError" })
