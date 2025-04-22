-- 📏 Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- 📐 Indentation
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 📄 Visual guides
vim.opt.colorcolumn = "81"
vim.opt.cursorline = true

-- 🧼 UI elements
vim.opt.laststatus = 0
vim.opt.showtabline = 4
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.wrap = false

-- ✂️ Formatting
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- no auto-commenting on new line

-- 💻 Mouse + clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- 🧭 Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- 🌙 Appearance
vim.opt.background = "dark"
vim.opt.autochdir = true

-- 🌐 Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 🔍 Syntax & filetypes
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
