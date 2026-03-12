-- ─────────────────────────────────────────────
-- 🌟 Neovim Init File for vscode-neovim (Lua)
-- ─────────────────────────────────────────────

-- Load core settings
dofile(vim.fn.stdpath("config") .. "/general/settings.lua")
dofile(vim.fn.stdpath("config") .. "/general/keys.lua")

-- VS Code-specific behavior
if vim.g.vscode then
  dofile(vim.fn.stdpath("config") .. "/vscode/settings.lua")
  -- Disable <C-d> in normal mode
  vim.keymap.set('n', '<C-d>', '<Nop>')
  -- Disable <C-d> in insert mode
  vim.keymap.set('i', '<C-d>', '<Nop>')
  -- Disable <C-d> in visual mode
  vim.keymap.set('v', '<C-d>', '<Nop>')
end

-- Load plugin system (lazy.nvim)
require("plugins.init")
