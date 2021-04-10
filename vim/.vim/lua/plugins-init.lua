return require('packer').startup(function()
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = true }
  
  use 'bluz71/vim-moonfly-colors'
  use 'dylanaraps/fff.vim'

  use 'glepnir/dashboard-nvim'
  use 'glepnir/indent-guides.nvim'
  use { 'glepnir/lspsaga.nvim' } -- requires nvim-lspconfig, but it's always installed regardless

  use 'hoob3rt/lualine.nvim'
  use 'hrsh7th/nvim-compe'
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
  use 'jiangmiao/auto-pairs' -- TODO: get rid of this, in favor of lua option - if possible

  use 'junegunn/vim-peekaboo'
  use { 'junegunn/fzf.vim', requires = 'junegunn/fzf' }

  use 'justinmk/vim-dirvish'
  use { 'keith/swift.vim', opt = true, ft = 'swift' }
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'mattn/emmet-vim'
  use 'neovim/nvim-lspconfig' 
  use 'norcalli/nvim-colorizer.lua'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {
    'numToStr/Navigator.nvim',
    config = function() require('Navigator').setup() end
  }
  use { 'prettier/vim-prettier', opt = true, cmd = { 'Prettier', 'PrettierAsync' }}

  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
end)
