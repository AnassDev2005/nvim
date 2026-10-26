-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("coding_workflow", { clear = true }),
  pattern = { "python", "c", "cpp" },
  callback = function(event)
    vim.bo[event.buf].expandtab = vim.bo[event.buf].filetype == "python"
    vim.bo[event.buf].shiftwidth = 4
    vim.bo[event.buf].tabstop = 4
    vim.bo[event.buf].softtabstop = 4
    if vim.bo[event.buf].filetype ~= "python" then
      vim.bo[event.buf].cindent = true
    end
    if vim.bo[event.buf].filetype == "python" then
      return
    end
    -- Angle brackets pair only in includes; '<' remains usable for comparisons.
    vim.keymap.set("i", "<", function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local before = vim.api.nvim_get_current_line():sub(1, col)
      if not vim.g.minipairs_disable and not vim.b.minipairs_disable and before:match("^%s*#%s*include%s*$") then
        return "<><Left>"
      end
      return "<"
    end, { buffer = event.buf, expr = true, desc = "Pair include brackets" })
    vim.keymap.set("i", ">", function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      if
        not vim.g.minipairs_disable
        and not vim.b.minipairs_disable
        and line:match("^%s*#%s*include%s*<")
        and line:sub(col + 1, col + 1) == ">"
      then
        return "<Right>"
      end
      return ">"
    end, { buffer = event.buf, expr = true, desc = "Skip closing include bracket" })
  end,
})
