-- Plugin Configurations
-- =====================
-- You'll find all initial configs & setups here, as well as custom plugin keybindings
local map = vim.api.nvim_set_keymap
local keyOpts = { silent = true, noremap = true }

-- Config: nvim-treesitter
require('nvim-treesitter.configs').setup {
  -- TODO: comment back in when parser migrations happens upstream || when I dig
  -- deeper and conclude things are safe
  -- ensure_installed = {"typescript", "javascript", "kotlin"},
  incremental_selection = {
      enable = true,
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  textobjects = { enable = true },
}

-- Config: compe
require('compe').setup {
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
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = false;
  };
}

-- Config: moonfly
-- vim.g.moonflyTransparent = 1

-- Config tokyonight
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_italic_functions = false
vim.cmd[[colorscheme tokyonight]]

-- Config: lualine.nvim
require('lualine').setup {
  options = {
    theme = 'tokyonight';
    icons_enabled = false;
    section_separators = {'', ''};
    component_separators = {'⟡', '⟡'};
  }
}

-- Config: Lspsaga
require('lspsaga').init_lsp_saga {
  border_style = "single"
}

map('n', 'gh', ':Lspsaga lsp_finder<cr>', keyOpts)
map('n', 'K',  ':Lspsaga hover_doc<cr>', keyOpts)
map('n', 'gs', ':Lspsaga signature_help<cr>', keyOpts)
map('n', 'gr', ':Lspsaga rename<cr>', keyOpts)
map('n', 'gd', ':Lspsaga preview_definition<cr>', keyOpts)
map('n', 'gl', ':Lspsaga show_line_diagnostics<cr>', keyOpts)
map('n', 'ca', ':Lspsaga code_action<cr>', keyOpts)

-- Config: colorizer
require('colorizer').setup {
  'javascript';
  'typescript';
  'css';
  javascript = { css = true; };
  typescript = { css = true; };
  css = { rgb_fn = true; };
}

-- Config: indent-blankline
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_filetype = {
  'lua',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'lua',
  'json',
  'yaml',
  'html',
  'swift',
  'c',
  'python',
  'dockerfile',
  'haskell',
}

-- Config: gitsigns 
require('gitsigns').setup {
  signs = {
    add = { text = '++', numhl='GitSignsAddNr' },
  }
}

-- Config: lir 
local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'

require'lir'.setup {
  show_hidden_files = true,
  devicons_enable = false,
  mappings = {
    ['l']     = actions.edit,
    ['<CR>']  = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['K']     = actions.mkdir,
    ['N']     = actions.newfile,
    ['R']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['D']     = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,
  },
  float = {
    size_percentage = 0.5,
    winblend = 10,
    border = true,
    borderchars = {"╔" , "═" , "╗" , "║" , "╝" , "═" , "╚", "║"},
  },
  hide_cursor = true,
}

map('n', '<Leader>f', ":lua require'lir.float'.toggle()<CR>", keyOpts)
map('n', '-', [[<CMD>execute 'e ' .. expand('%:p:h')<CR>]], keyOpts) -- netrw/dirvish file exp functionality

-- Config: vim-markdown-composer 
vim.g.markdown_composer_autostart = 0

-- Config: Fugitive
map('n', '<Leader>gc', ':Gcommit<cr>', keyOpts)

-- Config: Dashboard
vim.g.dashboard_default_executive = 'fzf'
vim.g.dashboard_custom_header = {
 ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
 ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
 ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
 ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
 ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
 ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}
vim.g.dashboard_custom_footer = { 
    '',
    '⢰⡟⣡⡟⣱⣿⡿⠡⢛⣋⣥⣴⣌⢿⣿⣿⣿⣿⣷⣌⠻⢿⣿⣿⣿⣿⣿⣿',
    '⠏⢼⡿⣰⡿⠿⠡⠿⠿⢯⣉⠿⣿⣿⣿⣿⣿⣿⣷⣶⣿⣦⣍⠻⢿⣿⣿⣿',
    '⣼⣷⢠⠀⠀⢠⣴⡖⠀⠀⠈⠻⣿⡿⣿⣿⣿⣿⣿⣛⣯⣝⣻⣿⣶⣿⣿⣿',
    '⣿⡇⣿⡷⠂⠈⡉⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣍⡤⣤⣤⣤⡀⠀⠉⠛⠿',
    '⣿⢸⣿⡅⣠⣬⣥⣤⣴⣴⣿⣿⢿⣿⣿⣿⣿⣿⣟⡭⡄⣀⣉⡀⠀⠀⠀⠀',
    '⡟⣿⣿⢰⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣶⣦⣈⠀⠀⠀⢀⣶',
    '⡧⣿⡇⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣾⣿',
    '⡇⣿⠃⣿⣿⣿⣿⣿⠛⠛⢫⣿⣿⣻⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿',
    '⡇⣿⠘⡇⢻⣿⣿⣿⡆⠀⠀⠀⠀⠈⠉⠙⠻⠏⠛⠻⣿⣿⣿⣿⣿⣭⡾⢁',
    '⡇⣿⠀⠘⢿⣿⣿⣿⣧⢠⣤⠀⡤⢀⣠⣀⣀⠀⠀⣼⣿⣿⣿⣿⣿⠟⣁⠉',
    '⣧⢻⠀⡄⠀⠹⣿⣿⣿⡸⣿⣾⡆⣿⣿⣿⠿⣡⣾⣿⣿⣿⣿⡿⠋⠐⢡⣶',
    '⣿⡘⠈⣷⠀⠀⠈⠻⣿⣷⣎⠐⠿⢟⣋⣤⣾⣿⣿⣿⡿⠟⣩⠖⢠⡬⠈⠀',
    '⣿⣧⠁⢻⡇⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⢀⠈⢀⡴⠈⠁⠀⠀',
    '⠻⣿⣆⠘⣿⠀⠀  ⠀⠈⠙⠛⠋⠉⠀⠀⠀⠀⡀⠤⠚⠁     ',
    '',
  }

map('n', '<Leader>fh', ':DashboardFindHistory<CR>', keyOpts)
map('n', '<Leader>ff', ':DashboardFindFile<CR>', keyOpts)
map('n', '<Leader>tc', ':DashboardChangeColorscheme<CR>', keyOpts)
map('n', '<Leader>fa', ':DashboardFindWord<CR>', keyOpts)
map('n', '<Leader>fb', ':DashboardJumpMark<CR>', keyOpts)
map('n', '<Leader>cn', ':DashboardNewFile<CR>', keyOpts)

-- Config: FZF
map('n', '<C-p>', ':Files<cr>', keyOpts)
map('n', '<Leader>b', ':Buffers<cr>', keyOpts)
map('n', '<Leader>h', ':History<cr>', keyOpts)
map('n', '<Leader>r', ':Rg<cr>', keyOpts)

-- Config: netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1 -- don't load default netrw
