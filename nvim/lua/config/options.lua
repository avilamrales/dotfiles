-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.clipboard = "unnamedplus"

vim.opt.updatetime = 1000

vim.diagnostic.config({
  virtual_text = false, -- Hide the text at the end of the line
  underline = true, -- Keep the colored underline
  update_in_insert = false, -- DO NOT update while typing
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})
