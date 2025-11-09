-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Telescope find files" })

-- Unset weird default buffer navigation
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Easy window resizing
vim.keymap.set("n", "<Up>", ":resize -5<CR>")
vim.keymap.set("n", "<Down>", ":resize +5<CR>")
vim.keymap.set("n", "<Left>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<Right>", ":vertical resize +5<CR>")

--"Fullscreen" using tab
vim.keymap.set("n", "<leader>z", ":tab split<CR>")

-- Easy split term
vim.keymap.set("n", "<leader>T", ":sp | term<CR>")

-- LSP
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "single" })
end, { desc = "Hover documentation" })
