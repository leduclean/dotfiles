-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Aller au début indenté
vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })

-- Aller à la fin de la ligne
vim.keymap.set("n", "L", "$", { desc = "Go to end of line" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor" })
