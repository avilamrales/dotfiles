-- 🧩 Bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

-- 🚀 Plugin Setup
require("lazy").setup({
  -- Hop
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("plug-config.hop")
    end,
    lazy = false
  },

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
    lazy = false
  },

  -- nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end,
    lazy = false
  },

  -- which-key.nvim
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
    lazy = false
  },

  -- telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plug-config.telescope")
    end,
    lazy = false
  }
})
