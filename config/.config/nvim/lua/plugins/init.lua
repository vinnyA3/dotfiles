return require('packer').startup(
  function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
  
    -- LSP and Autocomplete
    use 'neovim/nvim-lspconfig'
    use { 'glepnir/lspsaga.nvim' } -- requires nvim-lspconfig, but it's always installed regardless
    use 'hrsh7th/nvim-compe'

    -- Syntax & Lang
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'keith/swift.vim', opt = true, ft = 'swift' }

    -- Editing
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'mattn/emmet-vim'
    use 'jiangmiao/auto-pairs'

    -- Utilites and Editing Convenience
    use 'justinmk/vim-dirvish'
    use 'junegunn/vim-peekaboo'
    use { 'junegunn/fzf.vim', requires = 'junegunn/fzf' }
    use 'tpope/vim-fugitive'
    use 'dylanaraps/fff.vim'
    use {
      'euclio/vim-markdown-composer',
      opt = true,
      run = 'cargo build --release',
      cmd = { 'ComposerStart', 'ComposerOpen' },
      ft = 'markdown' } -- warning: vim-markdown-composer cargo, as it uses uses rust :)
    use 'glepnir/dashboard-nvim'
    use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

    -- Formatters
    use { 'prettier/vim-prettier', opt = true, cmd = { 'Prettier', 'PrettierAsync' }}

    -- Cosmetics
    use { 'bluz71/vim-moonfly-colors' }
    use {
      'lukas-reineke/indent-blankline.nvim',
      branch = 'lua',
      config = function() require('indent_blankline') end }
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'hoob3rt/lualine.nvim'
    use 'norcalli/nvim-colorizer.lua'
  end
)
