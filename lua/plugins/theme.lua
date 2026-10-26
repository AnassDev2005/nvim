return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    init = function()
      vim.o.background = "dark"
    end,
    opts = {
      contrast = "hard",
      transparent_mode = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
}
