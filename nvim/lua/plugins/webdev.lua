return {
  -- Database Management
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Package Info
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufRead package.json" },
    opts = {},
  },

  -- Extend Treesitter for Next.js/Tailwind
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "html", "css", "jsx" },
    },
  },

  -- Add inline colors to tailwind classes
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          on_attach = function(_, bufnr)
            local ok, colors = pcall(require, "tailwindcss-colors")
            if ok then
              colors.buf_attach(bufnr)
            end
          end,
        },
      },
    },
  },

  -- Config Picker & Explorer
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = opts.picker.sources.explorer or {}
      opts.picker.sources.explorer.layout = { layout = { position = "right" } }
    end,
    keys = {
      {
        "<leader>fc",
        function()
          require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
    },
  },

  -- Use prettierd as the default formater.
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 9000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- Intall prettierd with Mason
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
      },
    },
  },

  -- Better comment behaviour for js and ts.
  {

    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
}
