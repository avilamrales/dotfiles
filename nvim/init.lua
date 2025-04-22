-- ─────────────────────────────────────────────
-- 🌟 Neovim Init File for vscode-neovim (Lua)
-- ─────────────────────────────────────────────

-- Load core settings
dofile(vim.fn.stdpath("config") .. "/general/settings.lua")
dofile(vim.fn.stdpath("config") .. "/general/keys.lua")

-- VS Code-specific behavior
if vim.g.vscode then
  dofile(vim.fn.stdpath("config") .. "/vscode/settings.lua")
end

-- Load plugin system (lazy.nvim)
require("plugins.init")
