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
    use_languagetree = false,
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
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

-- Config: moonfly
vim.cmd('colorscheme moonfly')
vim.g.moonflyTransparent = 1

-- Config: lualine.nvim
require('lualine').setup {
  options = {
    theme = 'nightfly';
    icons_enabled = false;
    section_separators = {'', ''};
    component_separators = {'⟡', '⟡'};
  }
}

-- Config: Lspsaga
require('lspsaga').init_lsp_saga {
  border_style = 2
}

map('n', 'gh', 'Lspsaga lsp_finder<cr>', keyOpts)
map('n', 'K',  ':Lspsaga hover_doc<cr>', keyOpts)
map('n', 'gs', ':Lspsaga signature_help<cr>', keyOpts)
map('n', 'gr', ':Lspsaga rename<cr>', keyOpts)
map('n', 'gd', ':Lspsaga preview_definition<cr>', keyOpts)
map('n', 'gl', ':Lspsaga show_line_diagnostics<cr>', keyOpts)
map('n', 'ca', ':Lspsaga code_action<cr>', keyOpts)

-- Config: indent-guides
--  note: colors slightly altered for 'moonfly' colorscheme
-- local indent_fg='#16171c'
-- local indent_bg='#202126'

-- require('indent_guides').setup {
--   exclude_filetypes = {
--     'help',
--     'dashboard',
--     'dashpreview',
--     'sagahover',
--     'markdown',
--     'css',
--     'scss',
--     'fugitive',
--     'fugitiveblame',
--     'fzf',
--     'terminfo',
--   };
-- };

-- Config: colorizer
require('colorizer').setup {
  'javascript';
  'typescript';
  'css';
  javascript = { css = true; };
  typescript = { css = true; };
  css = { rgb_fn = true; };
}

-- Config: gitsigns 
require('gitsigns').setup {
  signs = {
    add = { text = '++', numhl='GitSignsAddNr' },
  }
}

-- Config: Fugitive
map('n', '<Leader>gc', ':Gcommit<cr>', keyOpts)

-- Config: fff 
map('n', '<Leader>f', ':F %:p:h<cr>', keyOpts)
--vim.g.fff#split = '30new'

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
 '    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠤⠖⠚⢉⣩⣭⡭⠛⠓⠲⠦⣄⡀⠀⠀⠀⠀⠀⠀⠀  ',
 '    ⠀⠀⠀⠀⠀⠀⢀⡴⠋⠁⠀⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠳⢦⡀⠀⠀⠀⠀  ',
 '    ⠀⠀⠀⠀⢀⡴⠃⢀⡴⢳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣆⠀⠀⠀  ',
 '    ⠀⠀⠀⠀⡾⠁⣠⠋⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠀⠀  ',
 '    ⠀⠀⠀⣸⠁⢰⠃⠀⠀⠀⠈⢣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣇⠀  ',
 '    ⠀⠀⠀⡇⠀⡾⡀⠀⠀⠀⠀⣀⣹⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀  ',
 '    ⠀⠀⢸⠃⢀⣇⡈⠀⠀⠀⠀⠀⠀⢀⡑⢄⡀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇  ',
 '    ⠀⠀⢸⠀⢻⡟⡻⢶⡆⠀⠀⠀⠀⡼⠟⡳⢿⣦⡑⢄⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇  ',
 '    ⠀⠀⣸⠀⢸⠃⡇⢀⠇⠀⠀⠀⠀⠀⡼⠀⠀⠈⣿⡗⠂⠀⠀⠀⠀⠀⠀⠀⢸⠁  ',
 '    ⠀⠀⡏⠀⣼⠀⢳⠊⠀⠀⠀⠀⠀⠀⠱⣀⣀⠔⣸⠁⠀⠀⠀⠀⠀⠀⠀⢠⡟⠀  ',
 '    ⠀⠀⡇⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀  ',
 '    ⠀⢸⠃⠘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⢀⠀⠀⠀⠀⠀⣾⠀⠀  ',
 '    ⠀⣸⠀⠀⠹⡄⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⡞⠀⠀⠀⠸⠀⠀⠀⠀⠀⡇⠀⠀  ',
 '    ⠀⡏⠀⠀⠀⠙⣆⠀⠀⠀⠀⠀⠀⠀⢀⣠⢶⡇⠀⠀⢰⡀⠀⠀⠀⠀⠀⡇⠀⠀  ',
 '    ⢰⠇⡄⠀⠀⠀⡿⢣⣀⣀⣀⡤⠴⡞⠉⠀⢸⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⣧⠀⠀  ',
 '    ⣸⠀⡇⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⢹⠀⠀⢸⠀⠀⢀⣿⠇⠀⠀⠀⠁⠀⢸⠀⠀  ',
 '    ⣿⠀⡇⠀⠀⠀⠀⠀⢀⡤⠤⠶⠶⠾⠤⠄⢸⠀⡀⠸⣿⣀⠀⠀⠀⠀⠀⠈⣇⠀  ',
 '    ⡇⠀⡇⠀⠀⡀⠀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠸⡌⣵⡀⢳⡇⠀⠀⠀⠀⠀⠀⢹⡀  ',
 '    ⡇⠀⠇⠀⠀⡇⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠮⢧⣀⣻⢂⠀⠀⠀⠀⠀⠀⢧  ',
 '    ⣇⠀⢠⠀⠀⢳⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡎⣆⠀⠀⠀⠀⠀⠘  ',
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

-- Config: Dirvish
vim.g.loaded_netrwPlugin = 1
vim.g.dirvish_relative_paths = 0
vim.cmd('command! -nargs=? -complete=dir Explore Dirvish <args>')
vim.cmd('command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>')
vim.cmd('command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>')

-- Config: markdown-preview.nvim
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_browser = 'chrome'
vim.g.mkdp_markdown_css = ''
vim.g.mkdp_highlight_css = ''
vim.g.mkdp_echo_preview_url = 1 
vim.g.mkdp_port = '8881'
vim.g.mkdp_page_title = '「${name}」'
