return require('packer').startup(
  function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
  
    use { 'bluz71/vim-moonfly-colors' }
    use 'dylanaraps/fff.vim'
    -- warning: vim-markdown-composer cargo, as it uses uses rust :)
    use {
	'euclio/vim-markdown-composer',
	opt = true,
	run = 'cargo build --release',
	cmd = { 'ComposerStart', 'ComposerOpen' },
	ft = 'markdown' }
    use 'glepnir/dashboard-nvim'
    use 'glepnir/indent-guides.nvim'
    use { 'glepnir/lspsaga.nvim' } -- requires nvim-lspconfig, but it's always installed regardless

    use 'hoob3rt/lualine.nvim'
    use 'hrsh7th/nvim-compe'
    use 'jiangmiao/auto-pairs'

    use 'junegunn/vim-peekaboo'
    use { 'junegunn/fzf.vim', requires = 'junegunn/fzf' }

    use 'justinmk/vim-dirvish'
    use { 'keith/swift.vim', opt = true, ft = 'swift' }
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'mattn/emmet-vim'
    use 'neovim/nvim-lspconfig' 
    use 'norcalli/nvim-colorizer.lua'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'prettier/vim-prettier', opt = true, cmd = { 'Prettier', 'PrettierAsync' }}

    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
  end
)
