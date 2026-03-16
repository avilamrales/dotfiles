-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Go to normal mode from insert mode
map("i", "jj", "<Esc>", { desc = "Escape insert mode" })
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "kj", "<Esc>", { desc = "Escape insert mode" })
map("i", "kk", "<Esc>", { desc = "Escape insert mode" })

-- Resize splits with Alt + hjkl
map("n", "<M-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<M-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
