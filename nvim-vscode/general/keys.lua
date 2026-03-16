-- 🧠 Set <Leader> to space (must be first)
vim.g.mapleader = " "

-- 🎯 Escape insert mode quickly
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")

-- 🧹 Ctrl+C as an alternate escape
vim.keymap.set("n", "<C-c>", "<Esc>")

-- 🧭 Window navigation (like VS Code split nav)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- 🔲 Resize editor splits
vim.keymap.set("n", "<M-j>", ":resize -2<CR>")
vim.keymap.set("n", "<M-k>", ":resize +2<CR>")
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>")

-- 💾 Leader-based save/quit
vim.keymap.set("n", "<Leader>s", ":w<CR>")       -- Save file
vim.keymap.set("n", "<Leader>q", ":wq!<CR>")     -- Save & quit
vim.keymap.set("n", "<Leader>b", ":bd<CR>")      -- Close buffer

-- 🪜 Move selected text in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")

-- 🚀 Hop.nvim Leader-based jump keys (to be used later)
vim.keymap.set("n", "<Leader>f", ":HopChar2<CR>", { silent = true })        -- Jump to 2-char
vim.keymap.set("n", "<Leader>w", ":HopWord<CR>", { silent = true })         -- Jump to word
vim.keymap.set("n", "<Leader>l", ":HopLineStart<CR>", { silent = true })    -- Jump to line
