-- 🧠 VSCode Comment Toggle Function
function _G.vscode_commentary(...)
  local args = {...}
  local line1, line2

  if #args == 0 then
    vim.opt.operatorfunc = "v:lua.vscode_commentary"
    return "g@"
  elseif #args > 1 then
    line1, line2 = args[1], args[2]
  else
    line1 = vim.fn.line("'[")
    line2 = vim.fn.line("']")
  end

  vim.fn.VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
end

-- 📚 VSCode WhichKey Support in Visual Mode
function _G.vscode_whichkey_visual()
  vim.cmd("normal! gv")
  local mode = vim.fn.visualmode()

  if mode == "V" then
    local startLine = vim.fn.line("v")
    local endLine = vim.fn.line(".")
    vim.fn.VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
  else
    local startPos = vim.fn.getpos("v")
    local endPos = vim.fn.getpos(".")
    vim.fn.VSCodeNotifyRangePos("whichkey.show",
      startPos[1], endPos[1], startPos[2], endPos[2], 1)
  end
end

-- 🧭 VS Code-like window navigation (Ctrl + hjkl)
vim.keymap.set({"n", "x"}, "<C-j>", function() vim.fn.VSCodeNotify("workbench.action.navigateDown") end, { silent = true })
vim.keymap.set({"n", "x"}, "<C-k>", function() vim.fn.VSCodeNotify("workbench.action.navigateUp") end, { silent = true })
vim.keymap.set({"n", "x"}, "<C-h>", function() vim.fn.VSCodeNotify("workbench.action.navigateLeft") end, { silent = true })
vim.keymap.set({"n", "x"}, "<C-l>", function() vim.fn.VSCodeNotify("workbench.action.navigateRight") end, { silent = true })

-- ✅ Fix Ctrl+/ comment behavior
vim.keymap.set("x", "<C-/>", "<Cmd>lua return vscode_commentary()<CR>", { expr = true })
vim.keymap.set("n", "<C-/>", "<Cmd>lua return vscode_commentary() .. '_' <CR>", { expr = true })

-- 📐 Toggle width shortcut
vim.keymap.set("n", "<C-w>_", function()
  vim.fn.VSCodeNotify("workbench.action.toggleEditorWidths")
end, { silent = true })

-- 🧠 Space to open which-key
vim.keymap.set("n", "<Space>", function() vim.fn.VSCodeNotify("whichkey.show") end, { silent = true })
vim.keymap.set("x", "<Space>", function() _G.vscode_whichkey_visual() end, { silent = true })

-- 🚀 VS Code Command Palette in visual mode
vim.keymap.set("x", "<C-P>", function()
  vim.cmd("call VSCodeNotify('workbench.action.showCommands')")
end, { silent = true })
