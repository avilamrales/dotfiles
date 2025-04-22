-- 🔭 Telescope Config
local telescope = require("telescope")

telescope.setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      preview_cutoff = 1,
      mirror = true,
    },
    sorting_strategy = "ascending",
    winblend = 10,
  },
})

-- Optional: keybinds
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help Tags" })
