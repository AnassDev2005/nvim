-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_picker = "telescope"
vim.g.autoformat = true
-- Plain .h files belong to the C/42 workflow; .hpp files remain C++.
vim.g.c_syntax_for_h = 1
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
